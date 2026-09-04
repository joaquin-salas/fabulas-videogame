class_name PlayerKnockbackState
extends PlayerStateBase

# ====================== EXPORT VARIABLES ======================
@export_category("Ragdoll Physics")
## How much energy is kept after a bounce (0.0 to 1.0). 0.5 means it loses 50% speed per impact.
@export var bounce_elasticity: float = 0.3
## Multiplier applied to the base fall gravity to make the ragdoll feel heavier.
@export var knockback_gravity_multiplier: float = 1.0
## Friction applied in the air to drastically slow down the initial explosive knockback.
@export var air_drag: float = 1800.0

@export_category("Ragdoll Behaviour")
## Time in seconds before the player regains control mid-air.
@export var knockback_duration: float = 1.0
## The minimum speed required to keep bouncing. Below this, the player recovers control.
@export var minimum_bounce_velocity: float = 300.0
## How much the player can steer their trajectory while in ragdoll.
@export var air_control_acceleration: float = 1800.0

# ====================== LOCAL VARIABLES ======================
var knockback_tween: Tween
var knockback_velocity_x: float = 0.0
var player_velocity_x: float = 0.0

func start() -> void:
	# Player uncontrolled/falling animation
	player.play_animation(PlayerAnimations.FALL) # TODO: Replace with ragdoll animation

	knockback_velocity_x = player.velocity.x
	player_velocity_x = 0.0
	
	# Start time-based recovery
	_start_knockback_timer()

func on_physics_process(delta: float) -> void:
	# Custom handling gravity
	var current_gravity: float = player.player_movement_stats.jump_gravity
	if player.velocity.y > 0:
		current_gravity = player.player_movement_stats.fall_gravity * knockback_gravity_multiplier
		
	# Apex Hang Time: If velocity is close to 0 on the Y axis, halve the gravity for a floaty apex
	if abs(player.velocity.y) < 150.0:
		current_gravity *= 0.5
		
	player.velocity.y += current_gravity * delta

	# Directional Influence (DI)
	# Applied after drag so the player can still steer slightly
	if direction != 0:
		player_velocity_x += direction * air_control_acceleration * delta
	else:
		player_velocity_x = move_toward(player_velocity_x, 0.0, (air_control_acceleration * 0.5) * delta)

	knockback_velocity_x = move_toward(knockback_velocity_x, 0.0, air_drag * delta)

	player.velocity.x = knockback_velocity_x + player_velocity_x


	# Ragdoll visual juice
	player.animated_sprite_2d.rotation += player.velocity.x * delta * 0.01
	
	# Pure Physics Movement
	var collision: KinematicCollision2D = player.move_and_collide(player.velocity * delta)
	
	# Bounce & Exit Conditions
	if collision:
		var normal: Vector2 = collision.get_normal()
			
		# Wall/Ceiling Bounce: Apply mathematical reflection directly to velocity
		player.velocity = player.velocity.bounce(normal) * bounce_elasticity

		knockback_velocity_x = player.velocity.x
		player_velocity_x = 0.0

		# Low Energy Tech (Exit Condition C): Recover if the bounce left us with no momentum
		if player.velocity.length() < minimum_bounce_velocity:
			player.velocity.x = 0.0 # Stabilize horizontal movement before returning control
			_exit_knockback()

func end() -> void:
	# Reset rotation to 0 when exiting knockback
	player.animated_sprite_2d.rotation = 0.0

	if knockback_tween and knockback_tween.is_valid():
		knockback_tween.kill()

# ******************* PRIVATE METHODS *******************
func _start_knockback_timer() -> void:
	if knockback_tween and knockback_tween.is_valid():
		knockback_tween.kill()
		
	knockback_tween = create_tween()
	knockback_tween.tween_callback(_exit_knockback).set_delay(knockback_duration)

func _exit_knockback() -> void:
	state_machine.change_state(PlayerStatesNames.FALLING)