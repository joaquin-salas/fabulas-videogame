class_name Player
extends CharacterBody2D

## Player movement configuration

# ====================== REFERENCE VARIABLES ======================
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var state_machine: StateMachine = $StateMachine
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var jump_buffer_timer: Timer = $Timers/JumpBufferTimer
@onready var inmortality_timer: Timer = $Timers/InmortalityTimer
@onready var hurtbox: Hurtbox = $Hurtbox

# ====================== RESOURCES ======================
@export var player_movement_stats: PlayerMovementStats

# ====================== LOCAL VARIABLES ======================
@export var max_health: int = 5
@onready var current_health: int = max_health:
	set(value):
		current_health = clamp(value, 0, max_health)
		SignalBus.player_health_changed.emit(current_health)
	get:
		return current_health

var is_invincible: bool = false
var blink_tween: Tween

# *********************** CALLBACKS **********************
func _ready() -> void:
	hurtbox.took_damage.connect(_on_hurtbox_took_damage)
	inmortality_timer.timeout.connect(_on_inmortality_timer_timeout)

	# Emit the signal after every node is ready to ensure that all nodes connect the signal before it is emitted.
	SignalBus.player_max_health_set.emit.call_deferred(max_health)

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

func take_damage(amount: int, knockback_dir: Vector2) -> void:
	if is_invincible:
		return
	
	current_health -= amount
	print("Player took damage: ", amount, " Current health: ", current_health)

	if current_health <= 0:
		die()
	else:
		is_invincible = true
		inmortality_timer.start()
		start_blinking()

		velocity = knockback_dir

		state_machine.change_state(PlayerStatesNames.HURT)

func die() -> void:
	state_machine.change_state(PlayerStatesNames.DEAD)

func start_blinking() -> void:
	# Create a tween that repeats indefinitely 
	blink_tween = create_tween()
	blink_tween.set_loops()

	blink_tween.tween_property(animated_sprite_2d, "material:shader_parameter/flash_modifier", 1.0, 0.1)
	blink_tween.tween_property(animated_sprite_2d, "material:shader_parameter/flash_modifier", 0.0, 0.1)

func print_debug(variables: Array) -> void:
	for i in variables:
		print(i)

# ******************* SIGNALS CALLBACKS *******************
func _on_hurtbox_took_damage(amount: int, knockback_dir: Vector2) -> void:
	take_damage(amount, knockback_dir)

func _on_inmortality_timer_timeout() -> void:
	is_invincible = false

	if blink_tween:
		blink_tween.kill()
		animated_sprite_2d.material.set_shader_parameter("flash_modifier", 0.0)
