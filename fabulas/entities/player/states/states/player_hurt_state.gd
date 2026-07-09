extends PlayerStateBase

# Tiempo en segundos que el jugador pierde el control
var hurt_duration: float = 0.15
var _current_timer: float = 0.0

func start() -> void:
	# Animación de Player herido
	player.play_animation(player.animations.Fall)
	SoundManager.play_sfx("Hurt")
	_current_timer = hurt_duration

func on_physics_process(delta: float) -> void:
	
	player.velocity.x = move_toward(player.velocity.x, 0, 800 * delta) # Esto no sirve mucho creo
	
	super.on_physics_process(delta)
	
	_current_timer -= delta
	if _current_timer <= 0.0:
		if player.is_on_floor():
			state_machine.change_state(player.states.Idle)
		else:
			state_machine.change_state(player.states.Falling)
