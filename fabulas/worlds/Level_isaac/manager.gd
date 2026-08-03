extends Node


@onready var area_sides: Area2D = $"../Areas/Area2DSides"
@onready var area_up: Area2D = $"../Areas/Area2DUp"
@onready var camera_rig_up: Node2D = $"../Cameras/CameraRigUp"
@onready var camera_rig_sides: Node2D = $"../Cameras/CameraRigSides"

func _ready() -> void:
	SoundManager.stop_voice()
	SoundManager.stop_music()
	SoundManager.play_music("Musica2")


func _on_area_2d_sides_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		camera_rig_sides.activate()

func _on_area_2d_up_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		camera_rig_up.activate()
