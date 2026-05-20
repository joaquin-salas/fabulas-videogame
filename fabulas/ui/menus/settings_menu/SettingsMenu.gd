extends Control
class_name SettingsMenu

signal closed

func _on_volumen_value_changed(value):
	AudioServer.set_bus_volume_db(0, linear_to_db(value / 100.0))

func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

func _on_resolution_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))

func _on_back_pressed() -> void:
	emit_signal("closed")
	self.visible = false
	
