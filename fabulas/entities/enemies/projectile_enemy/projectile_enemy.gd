@tool
extends CharacterBody2D

## Projectile Enemy that shoots projectiles at the player when detected
##
## It needs a child node of type [VisionArea] to detect the player and shoot projectiles at him.

# ====================== REFERENCE VARIABLES ======================
@onready var muzzle: Marker2D = $Muzzle
@onready var fire_cooldown: Timer = $FireCooldown
var vision_area: VisionArea = null

# ====================== LOCAL VARIABLES ======================
var player: Node2D = null
var can_fire: bool = true

# ====================== PRELOADS ======================
const PROJECTILE = preload("res://entities/enemies/projectile_enemy/projectile/projectile.tscn")

# *********************** CALLBACKS **********************
func _ready() -> void:
	if Engine.is_editor_hint():
		return

	# Find the VisionArea child node and connect its signals		
	for child in get_children():
		if child.name == "VisionArea":
			vision_area = child
			vision_area.player_spotted.connect(_on_player_spotted)
			vision_area.player_lost.connect(_on_player_lost)
			break

func _physics_process(_delta: float) -> void:
	if Engine.is_editor_hint():
		return
		
	if player == null or not can_fire:
		return

	fire()
	SoundManager.play_sfx("Shot")

# ********************* LOCAL FUNCTIONS ********************
func fire() -> void:
	can_fire = false
	fire_cooldown.start()
	var proj = PROJECTILE.instantiate()

	# Set projectile direction and position
	proj.direction = (player.global_position - muzzle.global_position).normalized()
	get_tree().current_scene.add_child(proj)
	proj.global_position = muzzle.global_position

# ******************* SIGNALS CALLBACKS *******************
func _on_player_spotted(target: Node2D) -> void:
	player = target

func _on_player_lost(_target: Node2D) -> void:
	player = null

func _on_fire_cooldown_timeout() -> void:
	can_fire = true

# ******************* EDITOR TOOLS *******************
func _get_configuration_warnings() -> PackedStringArray:
	var warnings = PackedStringArray()
	var has_vision = false
	
	for child in get_children():
		if child.name == "VisionArea":
			has_vision = true
			break
			
	if not has_vision:
		warnings.append(
			"⚠️ Blind Enemy: Add the component 'VisionArea' as a child for the enemy to be able to detect and shoot the player."
		)
		
	return warnings

func _notification(what: int) -> void:
	# Update configuration warnings in the editor in real time
	if what == NOTIFICATION_CHILD_ORDER_CHANGED and Engine.is_editor_hint():
		update_configuration_warnings()
