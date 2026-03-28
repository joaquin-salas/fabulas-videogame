class_name PlayerStateBase extends StateBase 

var gravity: Vector2

var direction: float:
	get:
		return Input.get_axis("move_left", "move_right")

var player: Player:
	set(value):
		controlled_node = value
	get:
		return controlled_node as Player

func _ready() -> void:
	gravity = (
		ProjectSettings.get_setting("physics/2d/default_gravity") * 
		ProjectSettings.get_setting("physics/2d/default_gravity_vector")
	)

func handle_gravity(delta: float) -> void:
	if not player.is_on_floor():
		player.velocity.y += gravity.y * delta

func on_physics_process(delta: float) -> void:
	handle_gravity(delta)
	player.move_and_slide()
