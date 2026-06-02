extends Control
class_name MainMenu


@onready var settings_menu: SettingsMenu = $CanvasLayer/SettingsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	SoundManager.play_music("Menu")
	$SettingsMenu.visible = false
	settings_menu.closed.connect(_on_settings_closed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().paused = false
	SceneManager.goto(SceneManager.SceneID.INTRO_CUTSCENE)


func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_settings_closed():
	settings_menu.visible = false
	self.visible = true
	
	
func _on_settings_pressed() -> void:
	settings_menu.visible = true
	self.visible = false
