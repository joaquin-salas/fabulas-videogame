extends CharacterBody2D

@export var speed = 100


var current_speed = speed
var GRAVITY = 980

var direction = 1




@onready var ray_cast_derecha: RayCast2D = $"RayCast/RayCast Derecha"
@onready var ray_cast_izquierda: RayCast2D = $"RayCast/RayCast Izquierda"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_izquierda_suelo: RayCast2D = $"RayCast/RayCast Izquierda suelo"
@onready var ray_cast_derecha_suelo: RayCast2D = $"RayCast/RayCast Derecha suelo"
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var collision_polygon_2d: CollisionPolygon2D = $CollisionPolygon2D


func _physics_process(delta: float) -> void:

	# gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta

# ── cambio de dirección ──────────────────────────────
	if ray_cast_derecha.is_colliding():
		direction = -1
	if ray_cast_izquierda.is_colliding():
		direction = 1
	if direction == 1 and not ray_cast_derecha_suelo.is_colliding():
		direction = -1
	if ray_cast_izquierda_suelo.is_colliding() == false:
		direction = 1
	if ray_cast_derecha_suelo.is_colliding() == false:
		direction = -1
# ── sincronización visual/física (una sola vez) ──────
	var facing_right = direction == 1
	animated_sprite.flip_h = not facing_right
	collision_polygon_2d.scale.x = 1 if facing_right else -1

	# movimiento
	velocity.x = direction * current_speed
	move_and_slide()
	
