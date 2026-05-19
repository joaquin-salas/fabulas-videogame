extends Node



func paused_game(pause: bool):
	get_tree().paused = pause

	if pause:
		var canvas: CanvasLayer = get_tree().current_scene.get_node("CanvasLayer")
		var pause_menu: PauseMenu = canvas.get_node("PauseMenu")
		
		pause_menu.visible = true
