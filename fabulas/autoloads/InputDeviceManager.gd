extends Node

signal device_changed(is_gamepad: bool)

var is_using_gamepad: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if is_using_gamepad:
			is_using_gamepad = false
			device_changed.emit(false)
	elif event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if not is_using_gamepad:
			is_using_gamepad = true
			device_changed.emit(true)
