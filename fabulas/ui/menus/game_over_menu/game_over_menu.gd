extends CanvasLayer

## Game Over Menu that appears when the player dies.

# ====================== REFERENCE VARIABLES ======================
@onready var color_rect: ColorRect = $ColorRect
@onready var retry_button: Button = $CenterContainer/MarginContainer/VBoxContainer/RetryButton
@onready var exit_button: Button = $CenterContainer/MarginContainer/VBoxContainer/ExitButton

# ************************ CALLBACKS **********************
func _ready() -> void:
	self.hide()

	# Connect the player_died signal to show the game over menu
	SignalBus.player_died.connect(_on_player_died)

	# Connect button signals
	retry_button.pressed.connect(_on_retry_button_pressed)
	exit_button.pressed.connect(_on_exit_button_pressed)

# ******************* SIGNAL CALLBACKS *******************
func _on_player_died() -> void:
	self.show()
	get_tree().paused = true

	var fade_in_tween = create_tween()
	fade_in_tween.tween_property(color_rect, "color", Color(0, 0, 0, 0.9), 1.9)
	
func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_exit_button_pressed() -> void:
	get_tree().paused = false
	SceneManager.goto(SceneManager.SceneID.MAIN_MENU)
