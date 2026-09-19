extends AnimatableBody2D

# ====================== REFERENCE VARIABLES ======================
@onready var activation_area = $ActivationArea

# ====================== EXPORTED VARIABLES ======================
@export var launch_height: float = 200.0
@export var launch_duration: float = 0.35
@export var return_delay: float = 0.4
@export var return_duration: float = 0.6

## How far the platform dips down before launching upward (spring effect).
@export var dip_depth: float = 12.0
## Duration of that dip phase.
@export var dip_duration: float = 0.1

## Fraction of the platform's real velocity that gets passed on to the Player's jump.
## 1.0 = added in full. Lower it if the jump feels too strong.
@export_range(0.0, 1.0, 0.05) var boost_multiplier: float = 0.5

## Hard cap on the boost velocity, applied AFTER boost_multiplier. This protects
## against the instantaneous velocity spikes that easing curves produce right at
## the dip -> launch transition (see comment in _launch()), where the raw
## per-frame velocity can be much higher than launch_height / launch_duration
## would suggest. Tune this against player_movement_stats.jump_force.
@export var max_boost_speed: float = 400.0

## When enabled, logs the platform's velocity every physics frame while moving,
## so you can tune height/duration/multiplier/cap by watching real numbers
## instead of guessing from launch_height and launch_duration alone.
@export var debug_log_velocity: bool = true

# ====================== LOCAL VARIABLES ======================
var _start_position: Vector2
var _previous_position: Vector2
var current_velocity: Vector2 = Vector2.ZERO
var _is_launching: bool = false
var _player_on_platform: Player = null

# *********************** BUILT IN CALLBACKS **********************
func _ready() -> void:
	activation_area.body_entered.connect(_on_activation_area_body_entered)
	activation_area.body_exited.connect(_on_activation_area_body_exited)

	_start_position = global_position
	_previous_position = global_position

func _physics_process(delta: float) -> void:
	# The platform's real velocity this frame, derived from its own
	# displacement. Does not depend on get_platform_velocity() or the
	# Player's Floor Layers.
	current_velocity = (global_position - _previous_position) / delta
	_previous_position = global_position
	
	var boosted_velocity: Vector2 = (current_velocity * boost_multiplier).limit_length(max_boost_speed)
	
	if debug_log_velocity:
		print(
			"LaunchPlatform velocity: %s -> after multiplier+cap: %s"
			% [current_velocity, boosted_velocity]
		)
	
	if _player_on_platform:
		_player_on_platform.boost_velocity = boosted_velocity

# ******************* PRIVATE FUNCTIONS *******************
func _launch() -> void:
	_is_launching = true
	
	var tween := create_tween()
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	
	
	tween.tween_property(
		self, 
		"global_position", 
		_start_position + Vector2.UP * launch_height, 
		launch_duration
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	
	tween.tween_interval(return_delay)
	
	tween.tween_property(
		self, 
		"global_position", 
		_start_position, 
		return_duration
	).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_callback(func() -> void: _is_launching = false)

# ******************* SIGNALS CALLBACKS *******************
func _on_activation_area_body_entered(body: Node2D) -> void:
	if not body is Player:
		return
	
	_player_on_platform = body
	body.boost_velocity = (current_velocity * boost_multiplier).limit_length(max_boost_speed)
	
	if not _is_launching:
		_launch()


func _on_activation_area_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	if _player_on_platform == body:
		_player_on_platform = null
	body.boost_velocity = Vector2.ZERO