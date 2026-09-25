extends CharacterBody2D

# ====================== REFERENCE VARIABLES ======================
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D

# ====================== EXPORT VARIABLES ======================
@export var speed: float = 500.0

# ===================== LOCAL VARIABLES ======================
var direction: Vector2 = Vector2.ZERO
const EXPLOSION_SCENE: PackedScene = preload("res://entities/enemies/projectile_enemy/projectile/explosion.tscn")

# *********************** BUILT IN CALLBACKS **********************
func _ready() -> void:
	visible_on_screen_notifier_2d.screen_exited.connect(_on_visible_on_screen_notifier_2d_screen_exited)

func _physics_process(delta: float) -> void:
	var collision: KinematicCollision2D = move_and_collide(direction * speed * delta)
	
	if collision:
		explode()

# ********************* LOCAL FUNCTIONS ********************
func explode() -> void:
	var explosion = EXPLOSION_SCENE.instantiate()
	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	queue_free()

# ********************** SIGNAL CALLBACKS **********************
## Destroy the projectile when it leaves the screen
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()