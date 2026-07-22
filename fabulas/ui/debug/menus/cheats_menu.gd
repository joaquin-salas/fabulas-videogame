extends "res://ui/debug/base_menu/base_menu.gd"

func on_accept():
	options[selected_index].activate()
func _ready() -> void:
	super._ready() 
	for option in options:
		if option.has_signal("toggled"):
			option.toggled.connect(_on_cheat_toggled.bind(option.option_id))
func _on_cheat_toggled(_value: bool, option_id: String) -> void:
	var player := get_tree().get_first_node_in_group("player")
	if not player:
		return
	
	match option_id:
		"GODFLY":
			player.toggle_god_mode()
		"invincible":
			DebugMenu.invincible = !DebugMenu.invincible
