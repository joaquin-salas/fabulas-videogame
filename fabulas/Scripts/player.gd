class_name Player
extends CharacterBody2D

## Player movement configuration

# ====================== REFERENCE VARIABLES ======================
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer_timer: Timer = $JumpBufferTimer

# ====================== RESOURCES ======================
@export var player_movement_stats: PlayerMovementStats
var states: PlayerStatesNames = PlayerStatesNames.new()
var animations: PlayerAnimations = PlayerAnimations.new()

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
