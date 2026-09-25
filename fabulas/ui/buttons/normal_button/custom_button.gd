extends Button
class_name  CustomButton

## Custom script for Buttons that plays a sound when pressed or hovered over.

# ******************* SIGNAL CALLBACKS *******************
func _on_pressed() -> void:
	SoundManager.play_ui("ClickButton")

func _on_mouse_entered() -> void:
	SoundManager.play_ui("EnterButton")
