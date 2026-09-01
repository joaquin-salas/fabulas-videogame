class_name PlayerKnockbackState
extends PlayerStateBase

# ====================== EXPORT VARIABLES ======================
## Time in seconds the player loses main control.
@export var knockback_duration: float = 0.5
## Massive friction to quickly decelerate the impact.
@export var knockback_friction: float = 3500.0 

func start() -> void:
	# Player uncontrolled/falling animation
	player.play_animation(PlayerAnimations.FALL) # TODO: Change animation and sfx
	SoundManager.play_sfx("Hurt")

	# Create a SceneTreeTimer via code and wait for it
	await get_tree().create_timer(knockback_duration).timeout
	
	# Safety check: only change state if the player wasn't interrupted by another hit
	if state_machine.current_state == self:
		if player.is_on_floor():
			state_machine.change_state(PlayerStatesNames.IDLE)
		else:
			state_machine.change_state(PlayerStatesNames.FALLING)

func on_physics_process(delta: float) -> void:
	# DIRECTIONAL INFLUENCE (DI)
	var target_speed = direction * player.player_movement_stats.speed_air 
	
	# Apply aggressive horizontal friction
	player.velocity.x = move_toward(player.velocity.x, target_speed, knockback_friction * delta)
	
	# The super call will handle gravity (decelerating Y naturally) and move_and_slide()
	super.on_physics_process(delta)