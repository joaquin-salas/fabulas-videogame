extends Node2D

## Camera that follows a specific node with a set of rules.

# ====================== REFERENCE VARIABLES ======================
@onready var camera: Camera2D = $Camera2D
@export var follow_node: Node2D 

@export var follow_y: bool = true
@export var follow_x: bool = false
@export var follow_speed: float = 6.0

@export var y_offset: float = -100.0
@export var x_offset: float = 0.0

@export var zoom_value: Vector2 = Vector2(1.0, 1.0)

func _ready() -> void:
	camera.zoom = zoom_value

func _process(delta: float) -> void:
	if follow_node == null:
		print("follow_node es null")
		return
	
	if follow_x:
		global_position.x = lerp(global_position.x, follow_node.global_position.x + x_offset, follow_speed * delta)
	
	if follow_y:
		global_position.y = lerp(global_position.y, follow_node.global_position.y + y_offset, follow_speed * delta)
