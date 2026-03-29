extends PlayerStateBase

func start() -> void:
	player.play_animation(player.animations.Jump)
	
	player.coyote_timer.stop()
	player.jump_buffer_timer.stop()
	
	player.velocity.y = player.player_movement_stats.jump_force

func on_physics_process(delta: float) -> void:
	player.handle_animation(direction)
	player.velocity.x = direction * player.player_movement_stats.speed_air
	
	if not Input.is_action_pressed("jump") and player.velocity.y < 0:
		player.velocity.y *= player.player_movement_stats.variable_jump_multiplier
		
	if player.velocity.y >= 0:
		state_machine.change_state(player.states.Falling)
	
	super.on_physics_process(delta)
