extends Node

enum SceneID {
	MAIN_MENU,
	INTRO_CUTSCENE,
	LEVEL_1
}

const SCENES := {
	SceneID.MAIN_MENU: "res://ui/menus/main_menu/main_menu.tscn",
	SceneID.INTRO_CUTSCENE: "res://worlds/scenes/cutscenes/intro/cutscene_intro1.tscn",
	SceneID.LEVEL_1: "res://worlds/scenes/level_1/level_1.tscn",
}

func goto(scene_id: SceneID) -> void:
	get_tree().change_scene_to_file(SCENES[scene_id])

func goto_path(path: String) -> void:
	get_tree().change_scene_to_file(path)

func paused_game(paused: bool) -> void:
	get_tree().paused = paused

	var canvas := get_tree().current_scene.get_node_or_null("CanvasLayer")
	if canvas == null:
		return

	var pause_menu := canvas.get_node_or_null("PauseMenu")
	if pause_menu:
		pause_menu.visible = paused
