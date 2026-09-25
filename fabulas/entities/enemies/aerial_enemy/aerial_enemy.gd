extends CharacterBody2D


# Enums rutas
enum Routes {
	ROUTE_A,
	ROUTE_B,
	ROUTE_C
}


# Exports 
@export var speed: float = 100.0
@export var wait_time: float = 2.0
@export var route: Routes


# Referencias a nodos 
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var agent = $NavigationAgent2D


# Variables 
var waypoints: Array = []
var current_index: int = 0
var is_waiting: bool = false
var target: Marker2D


# Funciones built-in
func _ready() -> void:
	setup_route()
	configure_agent()


func _physics_process(_delta: float) -> void:
	if is_waiting:
		play_animation(Vector2.ZERO)
		return
	
	move_towards_target()
	check_waypoint_reached()


# Funciones privadas 
func setup_route() -> void:
	var group_name = ""
	match route:
		Routes.ROUTE_A:
			group_name = "Route_A"
		Routes.ROUTE_B:
			group_name = "Route_B"
		Routes.ROUTE_C:
			group_name = "Route_C"
	
	waypoints = get_tree().get_nodes_in_group(group_name)
	if waypoints.is_empty():
		push_error("No waypoints found for route: " + group_name)
		return
	
	target = waypoints[current_index]


func configure_agent() -> void:
	agent.target_position = target.global_position
	agent.target_desired_distance = 5.0
	agent.path_desired_distance = 32.0


func move_towards_target() -> void:
	var next_point = agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	
	velocity = velocity.lerp(direction * speed, 0.33)
	move_and_slide()
	
	update_sprite_direction(direction)
	play_animation(direction)


func update_sprite_direction(direction: Vector2) -> void:
	if direction.x > 0:
		sprite_2d.flip_h = false
	elif direction.x < 0:
		sprite_2d.flip_h = true


func check_waypoint_reached() -> void:
	if not agent.is_navigation_finished():
		return
	
	current_index = (current_index + 1) % waypoints.size()
	target = waypoints[current_index]
	agent.target_position = target.global_position
	
	velocity = Vector2.ZERO
	is_waiting = true
	$Timer.start(wait_time)


func play_animation(_direction: Vector2) -> void:
	var anim_name = "eat" if is_waiting else "Fly"
	if animation_player.current_animation != anim_name:
		animation_player.play(anim_name)


# Señales
func _on_timer_timeout() -> void:
	is_waiting = false
