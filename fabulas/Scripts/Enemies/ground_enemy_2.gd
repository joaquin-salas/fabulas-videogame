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


func _physics_process(delta: float) -> void:

	# gravedad
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# cambio de dirección
	if ray_cast_derecha.is_colliding():
		direction = -1
		animated_sprite.flip_h = true

	if ray_cast_izquierda.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	if direction == 1 and not ray_cast_derecha_suelo.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	
	if ray_cast_derecha_suelo.is_colliding() == false:
		direction = -1
		animated_sprite.flip_h = true

	if ray_cast_izquierda_suelo.is_colliding() == false:
		direction = 1
		animated_sprite.flip_h = false

	# movimiento
	velocity.x = direction * current_speed
	move_and_slide()
	
