class_name PlayerGodFlyState
extends PlayerStateBase

var fly_speed: float = 1100.0

func start() -> void:
	player.velocity = Vector2.ZERO
	player.set_collision_mask_value(3, false)

func end() -> void:
	player.set_collision_mask_value(3, true)
	player.velocity = Vector2.ZERO

func on_physics_process(_delta: float) -> void:
	var vertical := Input.get_axis("move_up", "move_down")
	var input_vector := Vector2(direction, vertical)
	player.velocity = input_vector.normalized() * fly_speed
	player.handle_animation(direction)
	player.move_and_slide()
