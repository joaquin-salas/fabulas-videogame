extends CharacterBody2D

@export var speed : float
@export var WayPoints: Array[Marker2D]
@onready var animationPajaro=$AnimationPlayer
@onready var sprite2D=$Sprite2D
@export var wait_time := 2.0


var current_index = 0
var is_waiting= false
var target : Marker2D

func _ready():
	target = WayPoints[current_index]

func _physics_process(delta):
	if is_waiting:
		animation(Vector2.ZERO)
		return 
	var min_distance = 5.0
	var direction = target.global_position - global_position
	var distance = direction.length()
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, 0.05)
		
	move_and_slide()
	animation(direction)
	
	if distance <= min_distance:
		current_index += 1
	
		if current_index >= WayPoints.size():
			current_index = 0
	
		target = WayPoints[current_index]  
	
		velocity = Vector2.ZERO
		$Timer.start(wait_time)
		is_waiting = true
	
	if direction.x > 0:
		sprite2D.flip_h = false
	elif direction.x < 0:
		sprite2D.flip_h = true

func animation(direction):
	if is_waiting:
		if animationPajaro.current_animation != "eat":
			animationPajaro.play("eat")
	else:
		if animationPajaro.current_animation != "Fly":
			animationPajaro.play("Fly")


func _on_timer_timeout() -> void:
	is_waiting = false
