class_name Player
extends CharacterBody2D

## Main Player controller script

# ====================== REFERENCE VARIABLES ======================
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer
@onready var hurtbox: Hurtbox = $Hurtbox

# ====================== RESOURCES ======================
@export var player_movement_stats: PlayerMovementStats

# ====================== LOCAL VARIABLES ======================
var is_god_mode: bool = false

# *********************** CALLBACKS **********************
func _ready() -> void:
	add_to_group("player")
	hurtbox.took_knockback.connect(_on_hurtbox_took_knockback)
	if (CheckpointManager.checkpoint_active and SceneManager.get_current_scene_id() == CheckpointManager.current_scene):
		global_position = CheckpointManager.checkpoint_position
		TransitionsScreen.fade_in()
		
# ******************* LOCAL FUNCTIONS *******************	
func play_animation(animation_name: String) -> void:
	animated_sprite_2d.play(animation_name)

func handle_animation(direction: float) -> void:
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false

func get_current_gravity() -> float:
	if velocity.y > 0:
		return player_movement_stats.fall_gravity
	return player_movement_stats.jump_gravity

func received_knockback(knockback_dir: Vector2) -> void:
	if is_god_mode or DebugMenu.god_mode:
		return
	
	velocity = knockback_dir

	state_machine.change_state(PlayerStatesNames.HURT)

func toggle_god_mode() -> void:
	is_god_mode = !is_god_mode
	if is_god_mode:
		state_machine.change_state(PlayerStatesNames.GODFLY)
	else:
		state_machine.change_state(PlayerStatesNames.FALLING)
		
func print_debug(variables: Array) -> void:
	for i in variables:
		print(i)
		
# ******************* SIGNALS CALLBACKS *******************
func _on_hurtbox_took_knockback(knockback_dir: Vector2) -> void:
	received_knockback(knockback_dir)
