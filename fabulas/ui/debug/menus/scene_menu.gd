extends "res://ui/debug/base_menu/base_menu.gd" 

func on_accept():
	var option = options[selected_index]
	var scene_id = SceneManager.SceneID.get(option.option_id, null)
	if scene_id == null:
		return
	DebugMenu.toggle() 
	SceneManager.goto(scene_id)
