class_name PlayerKnockbackState
extends PlayerStateBase

# ====================== EXPORT VARIABLES ======================
## How much energy is kept after a bounce (0.0 to 1.0). 0.6 means it loses 40% speed per impact.
@export var bounce_elasticity: float = 0.6
## The minimum speed required to keep bouncing. Below this, the player recovers control.
@export var minimum_bounce_velocity: float = 50.0
## Maximum time in seconds before forcing recovery, preventing infinite loops in corners.
@export var failsafe_duration: float = 3.0
## How much the player can steer their trajectory while in ragdoll
@export var air_control_acceleration: float = 1800.0

func start() -> void:
	# Player uncontrolled/falling animation
	player.play_animation(PlayerAnimations.FALL)

	
	# Start failsafe timer organically without creating nodes
	_start_failsafe_timer()

func on_physics_process(delta: float) -> void:
	var pre_impact_velocity: Vector2 = player.velocity

	# 1. Directional Influence (DI): Allow the player to gently steer in the air
	if direction != 0:
		player.velocity.x += direction * air_control_acceleration * delta

	player.animated_sprite_2d.rotation += player.velocity.x * delta * 0.015
	
	super.on_physics_process(delta)
	
	if player.get_slide_collision_count() > 0:
		var collision: KinematicCollision2D = player.get_slide_collision(0)
		var normal: Vector2 = collision.get_normal()
		
		# Apply mathematical reflection using the original unaltered velocity
		player.velocity = pre_impact_velocity.bounce(normal) * bounce_elasticity
		
		# Optional juice: Rotate the sprite based on impact strength, or play sound
		# SoundManager.play_sfx("Bounce") 
			
	# 4. Exit Condition: Player is on the floor AND has lost kinetic energy
	if player.is_on_floor() and player.velocity.length() < minimum_bounce_velocity:
		_exit_knockback()

# ******************* PRIVATE METHODS *******************
func _start_failsafe_timer() -> void:
	# We await a SceneTreeTimer to prevent softlocks
	await get_tree().create_timer(failsafe_duration).timeout
	
	if state_machine.current_state == self:
		_exit_knockback()

func _exit_knockback() -> void:
	# Reset any visual rotations here if you added them (e.g. player.rotation = 0.0)
	player.animated_sprite_2d.rotation = 0.0

	if player.is_on_floor():
		state_machine.change_state(PlayerStatesNames.IDLE)
	else:
		state_machine.change_state(PlayerStatesNames.FALLING)