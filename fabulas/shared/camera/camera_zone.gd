@tool
class_name CameraZone
extends Area2D

## Camera Zone that change camera properties when the player enters the zone.

# ====================== CONST VARIABLES ======================
const ZOOM_FILL_COLOR := Color8(180, 130, 255, 60) # Morado claro transparente
const ZOOM_BORDER_COLOR := Color8(180, 130, 255, 200) # Morado sólido para el borde

# ====================== REFERENCE VARIABLES ======================
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# ====================== EXPORT VARIABLES ======================
@export_category("Zone Bounds")
@export var expand_left: float = 200.0:
  set(value):
    expand_left = value
    _update_shape()
    queue_redraw()

@export var expand_right: float = 200.0:
  set(value):
    expand_right = value
    _update_shape()
    queue_redraw()

@export var expand_top: float = 150.0:
  set(value):
    expand_top = value
    _update_shape()
    queue_redraw()

@export var expand_bottom: float = 150.0:
  set(value):
    expand_bottom = value
    _update_shape()
    queue_redraw()

@export_category("Camera Behaviour")
@export var zone_zoom: Vector2 = Vector2(1.0, 1.0):
  set(value):
    zone_zoom = value
    queue_redraw()

@export var zone_offset_x: float = 0.0:
  set(value):
    zone_offset_x = value
    queue_redraw()

@export var zone_offset_y: float = 0.0:
  set(value):
    zone_offset_y = value
    queue_redraw()

@export var zone_follow_x: bool = true
@export var zone_follow_y: bool = true
@export var zone_follow_speed: float = 6.0
@export var zone_priority: int = 0

@export_category("Camera Limits")
@export var use_limit_left: bool = true
@export var use_limit_right: bool = true
@export var use_limit_top: bool = true
@export var use_limit_bottom: bool = true

@export_category("Transition Settings")
@export var transition_duration: float = 0.8
@export var transition_trans_type: Tween.TransitionType = Tween.TRANS_SINE
@export var transition_ease_type: Tween.EaseType = Tween.EASE_OUT


# *********************** CALLBACKS **********************
func _ready() -> void:
  _update_shape()

  if not Engine.is_editor_hint():
    self.body_entered.connect(_on_body_entered)
    self.body_exited.connect(_on_body_exited)

# ******************* PRIVATE METHODS *******************
func _update_shape() -> void:
  if not is_inside_tree():
    return

  if collision_shape != null:
    var new_width := expand_left + expand_right
    var new_height := expand_top + expand_bottom
    collision_shape.shape.size = Vector2(new_width, new_height)
    
    var offset_x := (expand_right - expand_left) / 2.0
    var offset_y := (expand_bottom - expand_top) / 2.0
    collision_shape.position = Vector2(offset_x, offset_y)

func _draw() -> void:
  if Engine.is_editor_hint():
    var vp_width: float = ProjectSettings.get_setting("display/window/size/viewport_width", 1152)
    var vp_height: float = ProjectSettings.get_setting("display/window/size/viewport_height", 648)
    
    var cam_size := Vector2(vp_width / zone_zoom.x, vp_height / zone_zoom.y)
    
    var geometric_center := Vector2((expand_right - expand_left) / 2.0, (expand_bottom - expand_top) / 2.0)
    var cam_center := geometric_center + Vector2(zone_offset_x, zone_offset_y)
    
    var cam_top_left := cam_center - (cam_size / 2.0)
    var cam_rect := Rect2(cam_top_left, cam_size)
    
    draw_rect(cam_rect, ZOOM_FILL_COLOR, true)
    draw_rect(cam_rect, ZOOM_BORDER_COLOR, false, 2.0)

# ******************* SIGNALS CALLBACKS *******************
func _on_body_entered(body: Node2D) -> void:
  if body.is_in_group("player"):
    SignalBus.player_entered_camera_zone.emit(self)

func _on_body_exited(body: Node2D) -> void:
  if body.is_in_group("player"):
    SignalBus.player_exited_camera_zone.emit(self)

# ******************* PUBLIC METHODS *******************
## Returns the camera limits based on the zone's positions
func get_camera_limits() -> Dictionary:
  var pos = global_position
  return {
    "left": (pos.x - expand_left) if use_limit_left else -INF,
		"right": (pos.x + expand_right) if use_limit_right else INF,
		"top": (pos.y - expand_top) if use_limit_top else -INF,
		"bottom": (pos.y + expand_bottom) if use_limit_bottom else INF
  }

## Returns the real geometric center (centroid) of the zone in global coordinates
func get_zone_center() -> Vector2:
  var pos := global_position
  var offset_x := (expand_right - expand_left) / 2.0
  var offset_y := (expand_bottom - expand_top) / 2.0
  return pos + Vector2(offset_x, offset_y)