extends PlayerStateBase

## Idle State del nodo Player

func start() -> void:
	player.play_animation(player.animations.Run)
	
	if not player.jump_buffer_timer.is_stopped():
		state_machine.change_state(player.states.Jumping)

func on_physics_process(delta: float) -> void:
	player.handle_animation(direction)
	player.velocity.x = direction * player.player_movement_stats.speed_floor
	
	if not player.is_on_floor():
		player.coyote_timer.start()
		print("COYOTE TIMER -> ACTIVADO")
		state_machine.change_state(player.states.Falling)
	
	if direction == 0:
		state_machine.change_state(player.states.Idle)
	
	super.on_physics_process(delta)

func on_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		state_machine.change_state(player.states.Jumping)
