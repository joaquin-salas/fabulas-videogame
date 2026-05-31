extends PlayerStateBase

var _step_timer: float = 0.0
var _step_interval: float = 0.3

func start() -> void:
	player.play_animation(player.animations.Run)
	_step_timer = 0.0

func end() -> void:
	_step_timer = 0.0

func on_physics_process(delta: float) -> void:
	player.handle_animation(direction)
	player.velocity.x = direction * player.player_movement_stats.speed_floor
	
	_step_timer -= delta
	if _step_timer <= 0.0:
		SoundManager.play_sfx("Walk")
		_step_timer = _step_interval
	
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
