class_name Player
extends CharacterBody2D

## Player movement configuration

# ====================== REFERENCE VARIABLES ======================
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
#@onready var state_machine: StateMachine = $StateMachine

# ====================== RESOURCES ======================
var player_movement_stats: PlayerMovementStats = PlayerMovementStats.new()
var states: PlayerStatesNames = PlayerStatesNames.new()
var animations: PlayerAnimations = PlayerAnimations.new()

# ====================== LOCAL VARIABLES ======================
var gravity = (
	ProjectSettings.get_setting("physics/2d/default_gravity_vector") *
	ProjectSettings.get_setting("physics/2d/default_gravity")
)

# ******************* LOCAL FUNCTIONS *******************
func print_debug(variables: Array) -> void:
	for i in variables:
		print(i)

func play_animation(animation_name: String) -> void:
	animated_sprite_2d.play(animation_name)

func handle_animation(direction: float) -> void:
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity.y * delta

# ******************* CALLBACKS *******************
func _ready() -> void:
	print('resource PlayerMovementStats: ', player_movement_stats)

#func _physics_process(delta: float) -> void:
	##state_machine._physics_process(delta)
	#handle_gravity(delta)
	#move_and_slide()
