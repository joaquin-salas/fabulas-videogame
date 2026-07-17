extends CharacterBody2D


# ====================== REFERENCE VARIABLES ======================
@onready var ray_cast_left: RayCast2D = $"RayCast/RayCastLeft"
@onready var ray_cast_right: RayCast2D = $"RayCast/RayCastRight"
@onready var ray_cast_left_floor: RayCast2D = $"RayCast/RayCastLeftFloor"
@onready var ray_cast_right_floor: RayCast2D = $"RayCast/RayCastRightFloor"

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# ====================== LOCAL VARIABLES ======================
@export var speed = 100
@onready var current_speed = speed

const GRAVITY: int = 980
var direction: int = 1

# *********************** CALLBACKS **********************
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if ray_cast_right.is_colliding():
		direction = -1
	if ray_cast_left.is_colliding():
		direction = 1
	if direction == 1 and not ray_cast_right_floor.is_colliding():
		direction = -1
	if ray_cast_left_floor.is_colliding() == false:
		direction = 1
	if ray_cast_right_floor.is_colliding() == false:
		direction = -1

# ── sincronización visual/física (una sola vez) ──────
	var facing_right = direction == 1
	animated_sprite.flip_h = not facing_right
	collision_polygon_2d.scale.x = 1 if facing_right else -1

	# movimiento
	velocity.x = direction * current_speed
	move_and_slide()
	
