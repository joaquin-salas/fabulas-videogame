extends Node2D

@onready var keys_hud: CanvasLayer = $Menus/KeysHud
@onready var camera_rig: Node2D = $CameraRig


func _ready() -> void:
	SoundManager.stop_music()
	TransitionsScreen.fade_in()

	SignalBus.hud_off.connect(_on_hud_off)
	SignalBus.hud_on.connect(_on_hud_on)

	_teleport_player()


func _teleport_player() -> void:
	if SceneManager.teleport_marker == "":
		return

	var marker = $DebugTeleport.get_node_or_null(
		SceneManager.teleport_marker
	)

	if marker == null:
		return

	var player = get_tree().get_first_node_in_group("player")

	if player:
		player.global_position = marker.global_position
		camera_rig.global_position = marker.global_position


func _on_hud_off() -> void:
	keys_hud.visible = false


func _on_hud_on() -> void:
	keys_hud.visible = true
