extends AnimatableBody2D

# ====================== REFERENCE VARIABLES ======================
@onready var activation_area = $ActivationArea
@onready var boost_coyote_timer = $BoostCoyoteTimer

# ====================== EXPORTED VARIABLES ======================
## Maximum height the platform will reach
@export var launch_height: float = 300.0
## Time to reach launch height
@export var launch_duration: float = 0.75
## Time before moving to the start position
@export var return_delay: float = 1.0
## Time to reach the start position
@export var return_duration: float = 1.0

## Fraction of the platform's real velocity that gets passed on to the Player's jump
@export_range(0.0, 2.0, 0.01) var boost_multiplier: float = 0.4

## How long the last significant platform velocity stays available after the
## platform has stopped moving. Same idea as the Player's coyote_timer,
## applied to the platform's velocity instead of its floor state.
@export var boost_grace_time: float = 0.15
## Below this speed, the platform is considered "stopped" for boost purposes.
@export var boost_grace_threshold: float = 1.0

## Logs the platform's velocity every physics frame while moving
@export var debug_log_velocity: bool = false

# ====================== LOCAL VARIABLES ======================
var _start_position: Vector2
var _previous_position: Vector2
var current_velocity: Vector2 = Vector2.ZERO
var _is_launching: bool = false
var _player_on_platform: Player = null

var _last_significant_velocity: Vector2 = Vector2.ZERO

# *********************** BUILT IN CALLBACKS **********************
func _ready() -> void:
	activation_area.body_entered.connect(_on_activation_area_body_entered)
	activation_area.body_exited.connect(_on_activation_area_body_exited)

	boost_coyote_timer.one_shot = true
	boost_coyote_timer.wait_time = boost_grace_time

	_start_position = global_position
	_previous_position = global_position

func _physics_process(delta: float) -> void:
	current_velocity = (global_position - _previous_position) / delta
	_previous_position = global_position

	if current_velocity.length() > boost_grace_threshold:
		_last_significant_velocity = current_velocity
		boost_coyote_timer.start()
	
	var boosted_velocity: Vector2 = _get_boosted_velocity()
	
	if debug_log_velocity and current_velocity.length() > 0.1:
		print(
			"LaunchPlatform velocity: %s -> after multiplier+cap: %s"
			% [current_velocity, boosted_velocity]
		)
	
	if _player_on_platform:
		_player_on_platform.boost_velocity = boosted_velocity

# ******************* PRIVATE FUNCTIONS *******************
func _get_boosted_velocity() -> Vector2:
	# While the coyote timer is still running, use the last velocity that was
	# actually significant, not the current (possibly zero) one, so a jump
	# right as the platform settles still gets the boost.
	var effective_velocity: Vector2 = (
		_last_significant_velocity if not boost_coyote_timer.is_stopped() else current_velocity
	)
	return effective_velocity * boost_multiplier

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
	body.boost_velocity = _get_boosted_velocity()
	
	if not _is_launching:
		_launch()
 
func _on_activation_area_body_exited(body: Node2D) -> void:
	if not body is Player:
		return
	
	if _player_on_platform == body:
		_player_on_platform = null
	body.boost_velocity = Vector2.ZERO