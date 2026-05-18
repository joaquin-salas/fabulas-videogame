extends CharacterBody2D

@export var speed = 100
@export var chase_speed = 300

var current_speed = speed
var GRAVITY = 980

var direction = 1
var player_detected = false
var chase_timer = 0.0
var CHASE_TIME = 2.0

@onready var area_derecha: Area2D = $Areas/area_derecha
@onready var area_izquierda: Area2D = $Areas/area_izquierda
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
	area_derecha.monitoring = direction == 1
	area_izquierda.monitoring = direction == -1
	
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

	# chase timer
	if player_detected:
		chase_timer = CHASE_TIME

	if chase_timer > 0:
		chase_timer -= delta
		current_speed = chase_speed
		animated_sprite.play("run")
	else:
		current_speed = speed
		animated_sprite.play("walk")

	# movimiento
	velocity.x = direction * current_speed
	move_and_slide()
	


func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_detected = true


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_detected = false
