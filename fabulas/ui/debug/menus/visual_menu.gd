extends "res://ui/debug/base_menu/base_menu.gd"


func _ready():
	super._ready()
	for option in options:
		if option.option_id == "collisions":
			option.toggled.connect(_on_collisions_toggled)

func _on_collisions_toggled(value: bool):
	DebugMenu.show_collisions = value
