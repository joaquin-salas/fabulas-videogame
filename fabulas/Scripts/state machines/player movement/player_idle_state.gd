extends PlayerStateBase

## Idle State del nodo Player

func start() -> void:
	player.play_animation(player.animations.Idle)

func on_physics_process(delta: float) -> void:
	player.velocity.x = 0
	handle_gravity(delta)
	player.move_and_slide()

func on_input(event) -> void:
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		state_machine.change_state(player.states.Running)
