@tool
class_name MovingPlatform
extends Path2D

## Moving Platform that follows a path defined by a Path2D node. You can set the speed, transition curve, the followed path and the sprite of the platform on the editor.
## Also you can preview the configuration on the editor

# ====================== REFERENCE VARIABLES ======================
@onready var platform_sprite: Sprite2D = $AnimatableBody2D/Sprite2D
@onready var collision_shape: CollisionShape2D = $AnimatableBody2D/CollisionShape2D
@onready var path_follow: PathFollow2D = $PathFollow2D

# ====================== LOCAL VARIABLES ======================
@export_category("Visuals")

@export var external_texture: Texture2D:
	set(value):
		external_texture = value

		if is_node_ready():
			_update_visual_and_collision()

@export_category("Behaviour")

@export var duration: float = 3.0
@export var transition_type: Tween.TransitionType = Tween.TRANS_LINEAR
@export var ease_type: Tween.EaseType = Tween.EASE_IN_OUT
@export var is_ping_pong: bool = false

@export_category("Tools")

var _editor_tween: Tween
@export var play_editor_movement: bool = false:
	set(value):
		play_editor_movement = value

		if is_node_ready() and Engine.is_editor_hint() and play_editor_movement:
			_start_preview()
		else:
			_stop_preview()


# *********************** CALLBACKS **********************
func _ready() -> void:
	# assert stop the game if the condition is false and throw a message.
	assert(external_texture != null, "Platform texture is missing!")
	_update_visual_and_collision()

	if not Engine.is_editor_hint():
		start_movement()

# ******************* LOCAL FUNCTIONS *******************
func _update_visual_and_collision():

	platform_sprite.texture = external_texture

	if external_texture != null:
		var rectangle_shape = RectangleShape2D.new()
		rectangle_shape.size = external_texture.get_size()
		collision_shape.shape = rectangle_shape
	else:
		collision_shape.shape = null
		
func start_movement():
	var movement_tween = create_tween()
	movement_tween.bind_node(self)
	movement_tween.set_loops()

	movement_tween.set_trans(transition_type)
	movement_tween.set_ease(ease_type)

	if is_ping_pong:
		movement_tween.tween_property(path_follow, "progress_ratio", 1.0, duration)
		movement_tween.tween_property(path_follow, "progress_ratio", 0.0, duration)
	else:
		movement_tween.tween_property(path_follow, "progress_ratio", 1.0, duration).from(0.0)		


# ******************* EDITOR PREVIEW FUNCTIONS *******************
func _start_preview() -> void:
	_stop_preview() 
	
	_editor_tween = create_tween()
	_editor_tween.bind_node(self)
	_editor_tween.set_loops()
	_editor_tween.set_trans(transition_type)
	_editor_tween.set_ease(ease_type)

	if is_ping_pong:
		_editor_tween.tween_property(path_follow, "progress_ratio", 1.0, duration)
		_editor_tween.tween_property(path_follow, "progress_ratio", 0.0, duration)
	else:
		_editor_tween.tween_property(path_follow, "progress_ratio", 1.0, duration).from(0.0)

func _stop_preview() -> void:
	if _editor_tween and _editor_tween.is_valid():
		_editor_tween.kill()
	
	if path_follow:
		path_follow.progress_ratio = 0.0