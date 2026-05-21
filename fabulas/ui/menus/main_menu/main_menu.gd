extends Control
class_name MainMenu

@onready var settings_menu: SettingsMenu = $SettingsMenu
@onready var menu_music: AudioStreamPlayer = $menu_music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	menu_music.play()	
	$SettingsMenu.visible = false
	settings_menu.closed.connect(_on_settings_closed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://levels/level_1.tscn")
	


func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_closed():
	$MarginContainer.visible = true
	$MarginContainer/VBoxContainer/Titulo.visible = true
	
	
func _on_settings_pressed() -> void:
	$SettingsMenu.visible = true
	$MarginContainer.visible = false
	$MarginContainer/VBoxContainer/Titulo.visible = false
