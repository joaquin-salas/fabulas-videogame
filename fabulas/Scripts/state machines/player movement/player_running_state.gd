extends PlayerStateBase

## Idle State del nodo Player

func start() -> void:
	player.play_animation(player.animations.Run)

func on_physics_process(delta: float) -> void:
	player.handle_animation(player.velocity.x)

	var direction = Input.get_axis("move_left", "move_right")
	player.velocity.x = direction * player.player_movement_stats.speed_floor
	
	handle_gravity(delta)
	player.move_and_slide()
	
func on_input(event) -> void:
	if not Input.is_action_pressed("move_left") or not Input.is_action_pressed("move_right") or controlled_node.velocity.x == 0:
		state_machine.change_state(player.states.Idle)
