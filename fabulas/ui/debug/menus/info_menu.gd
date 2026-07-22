extends "res://ui/debug/base_menu/base_menu.gd"

func on_accept():
	options[selected_index].activate()

func _ready() -> void:
	super._ready()
	for option in options:
		if option.has_signal("toggled"):
			option.toggled.connect(_on_info_toggled.bind(option.option_id))

func _on_info_toggled(_value: bool, option_id: String) -> void:
	match option_id:
		"info_panel":
			DebugMenu.show_info_panel = !DebugMenu.show_info_panel
