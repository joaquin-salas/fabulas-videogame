class_name VisionArea
extends Area2D

## Vision area component that detects the player 

# ====================== REFERENCE VARIABLES ======================
@onready var ray_cast_2d: RayCast2D = $RayCast2D

# ====================== LOCAL VARIABLES ======================
var current_target: Node2D = null
var is_spotted: bool = false

# ====================== CUSTOM SIGNALS ======================
signal player_spotted(target: Node2D)
signal player_lost(target: Node2D)

# *********************** BUILT-IN CALLBACKS **********************
func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _physics_process(_delta: float) -> void:
	if current_target == null:
		return
		
	ray_cast_2d.target_position = to_local(current_target.global_position)
	ray_cast_2d.force_raycast_update()

	if ray_cast_2d.is_colliding() and ray_cast_2d.get_collider() == current_target:
		if not is_spotted:
			is_spotted = true
			player_spotted.emit(current_target)
	else:
		if is_spotted:
			is_spotted = false
			player_lost.emit(current_target)

# ******************* SIGNALS CALLBACKS *******************
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		current_target = body

func _on_body_exited(body: Node2D) -> void:
	if body == current_target:
		current_target = null
		
		if is_spotted:
			is_spotted = false
			player_lost.emit(body)
