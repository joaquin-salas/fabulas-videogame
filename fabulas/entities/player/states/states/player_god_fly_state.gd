class_name PlayerGodFlyState
extends PlayerStateBase

@export var fly_speed: float = 400.0

func start() -> void:
	player.velocity = Vector2.ZERO
	player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(1, false)

func end() -> void:
	player.set_collision_layer_value(1, true)
	player.set_collision_mask_value(1, true)
	player.velocity = Vector2.ZERO

func on_physics_process(delta: float) -> void:
	var vertical := Input.get_axis("move_up", "move_down")
	var input_vector := Vector2(direction, vertical)
	player.velocity = input_vector.normalized() * fly_speed
	player.handle_animation(direction)
	player.move_and_slide()

func on_input(event: InputEvent) -> void:
	pass
