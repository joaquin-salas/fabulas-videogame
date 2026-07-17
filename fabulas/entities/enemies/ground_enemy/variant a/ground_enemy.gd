extends CharacterBody2D

# ====================== REFERENCE VARIABLES ======================
@onready var ray_cast_left: RayCast2D = $"RayCast/RayCastLeft"
@onready var ray_cast_right: RayCast2D = $"RayCast/RayCastRight"
@onready var ray_cast_left_floor: RayCast2D = $"RayCast/RayCastLeftFloor"
@onready var ray_cast_right_floor: RayCast2D = $"RayCast/RayCastRightFloor"

@onready var area_right: Area2D = $Areas/AreaRight
@onready var area_left: Area2D = $Areas/AreaLeft

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# ====================== LOCAL VARIABLES ======================
@export var speed: int = 100
@onready var current_speed: int = speed

@export var chase_speed: int = 300
@export var chase_time = 2.0
var chase_timer = 0.0

var GRAVITY: int = 980
var direction = 1
var player_detected = false

# *********************** CALLBACKS **********************
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += GRAVITY * delta

	# cambio de dirección
	area_right.monitoring = direction == 1
	area_left.monitoring = direction == -1
	
	if ray_cast_right.is_colliding():
		direction = -1
		animated_sprite.flip_h = true

	if ray_cast_left.is_colliding():
		direction = 1
		animated_sprite.flip_h = false

	if direction == 1 and not ray_cast_right_floor.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	
	if ray_cast_right_floor.is_colliding() == false:
		direction = -1
		animated_sprite.flip_h = true

	if ray_cast_left_floor.is_colliding() == false:
		direction = 1
		animated_sprite.flip_h = false

	# chase timer
	if player_detected:
		chase_timer = chase_time

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
	

# *********************** SIGNAL CALLBACKS **********************
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_detected = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_detected = false