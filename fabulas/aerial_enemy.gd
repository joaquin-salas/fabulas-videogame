extends CharacterBody2D

@export var speed : float
@onready var animationPajaro=$AnimationPlayer
@onready var sprite2D=$Sprite2D
@export var wait_time := 2.0
@export var route: Routes
@onready var agent = $NavigationAgent2D

enum Routes {
	ROUTE_A,
	ROUTE_B,
	ROUTE_C
}


var WayPoints: Array = []
var current_index = 0
var is_waiting= false
var target : Marker2D


func _ready():
	var group_name = ""

	match route:
		Routes.ROUTE_A:
			group_name = "Route_A"
		Routes.ROUTE_B:
			group_name = "Route_B"
		Routes.ROUTE_C:
			group_name = "Route_C"
	WayPoints = get_tree().get_nodes_in_group(group_name)
	target = WayPoints[current_index]
	agent.target_position = target.global_position
	agent.target_desired_distance = 5.0
	
	
	

func _physics_process(delta):
	if is_waiting:
		animation(Vector2.ZERO)
		return

	var next_point = agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()

	velocity = velocity.lerp(direction * speed, 0.5)
	move_and_slide()

	animation(direction)

	if direction.x > 0:
		sprite2D.flip_h = false
	elif direction.x < 0:
		sprite2D.flip_h = true

	makePath()



func makePath() -> void:
	if agent.is_navigation_finished():
		current_index += 1

		if current_index >= WayPoints.size():
			current_index = 0

		target = WayPoints[current_index]
		agent.target_position = target.global_position
		agent.set_target_position(target.global_position)

		velocity = Vector2.ZERO
		$Timer.start(wait_time)
		is_waiting = true


func animation(direction):
	if is_waiting:
		if animationPajaro.current_animation != "eat":
			animationPajaro.play("eat")
	else:
		if animationPajaro.current_animation != "Fly":
			animationPajaro.play("Fly")


func _on_timer_timeout() -> void:
	is_waiting = false
