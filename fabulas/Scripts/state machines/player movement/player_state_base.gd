class_name PlayerStateBase extends StateBase 

var gravity: Vector2 = (
		ProjectSettings.get_setting("physics/2d/default_gravity") * 
		ProjectSettings.get_setting("physics/2d/default_gravity_vector")
	)

var player: Player:
	set(value):
		controlled_node = value
	get:
		return controlled_node as Player

func handle_gravity(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y = gravity.y * delta

#func on_physics_process(delta: float) -> void:
	#handle_gravity(delta)
	#player.move_and_slide()
