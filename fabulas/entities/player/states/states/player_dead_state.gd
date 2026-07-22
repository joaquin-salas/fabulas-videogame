extends PlayerStateBase

func start() -> void:
	player.play_animation(PlayerAnimations.DEAD)
	SoundManager.play_sfx("Death")
	await player.animated_sprite_2d.animation_finished
	player.animated_sprite_2d.hide()
	SignalBus.player_died.emit()

func on_physics_process(delta: float) -> void:
	player.velocity = Vector2.ZERO
	super.on_physics_process(delta)
