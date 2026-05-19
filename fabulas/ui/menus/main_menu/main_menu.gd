extends Control
class_name MainMenu

@onready var menu_music: AudioStreamPlayer = $menu_music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	menu_music.play()	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/level_1.tscn")
	


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_config_pressed() -> void:
	get_tree().change_scene_to_file("res://config")
