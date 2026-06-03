extends Control
class_name PauseMenu

@onready var settings_menu = $"../SettingsMenu"

func _ready():
	settings_menu.closed.connect(_on_settings_closed)

func _on_resume_pressed() -> void:
	self.visible = false
	SceneManager.paused_game(false)

func _on_settings_pressed() -> void:
	settings_menu.visible = true
	self.visible = false

func _on_settings_closed():
	self.visible = true

func _on_exit_pressed() -> void:
	SceneManager.goto(SceneManager.SceneID.MAIN_MENU)
