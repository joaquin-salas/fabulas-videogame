extends Node2D

var SPEED = 100

var direction = 1
var player_detected = false
var chase_timer = 0.0
var CHASE_TIME = 2.0 

@onready var ray_cast_derecha: RayCast2D = $"RayCast Derecha"
@onready var ray_cast_izquierda: RayCast2D = $"RayCast Izquierda"
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var ray_cast_der_jugador: RayCast2D = $"RayCast der Jugador"
@onready var ray_cast_izq_jugador: RayCast2D = $"RayCast izq jugador"




func _ready() -> void:
	pass 



func _process(delta: float) -> void:

	var player_detected = false


	if ray_cast_derecha.is_colliding():
		direction = -1
		animated_sprite.flip_h = true

	if ray_cast_izquierda.is_colliding():
		direction = 1
		animated_sprite.flip_h = false



	if direction == 1:

		ray_cast_der_jugador.enabled = true
		ray_cast_izq_jugador.enabled = false

		if ray_cast_der_jugador.is_colliding():
			var obj = ray_cast_der_jugador.get_collider()
			if obj.is_in_group("player"):
				player_detected = true

	else:

		ray_cast_der_jugador.enabled = false
		ray_cast_izq_jugador.enabled = true

		if ray_cast_izq_jugador.is_colliding():
			var obj = ray_cast_izq_jugador.get_collider()
			if obj.is_in_group("player"):
				player_detected = true



	if player_detected:
		chase_timer = CHASE_TIME

	if chase_timer > 0:
		chase_timer -= delta
		SPEED = 300
		animated_sprite.play("run")
	else:
		SPEED = 100
		animated_sprite.play("walk")


	position.x += direction * SPEED * delta
	
