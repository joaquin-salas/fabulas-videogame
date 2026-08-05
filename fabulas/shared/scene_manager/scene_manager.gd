extends Node

var current_scene_id: SceneID

enum SceneID {
	MAIN_MENU,
	INTRO_CUTSCENE,
	LEVEL_ISAAC,
	LEVEL_JOA
}

const SCENES := {
	SceneID.MAIN_MENU: "res://ui/menus/main_menu/main_menu.tscn",
	SceneID.INTRO_CUTSCENE: "res://worlds/scenes/cutscenes/intro/cutscene_intro1.tscn",
	SceneID.LEVEL_ISAAC:"res://worlds/Level_isaac/Level_isaac.tscn",
	SceneID.LEVEL_JOA: "res://worlds/level_test/level_test.tscn"
}

func goto(scene_id: SceneID) -> void:
	current_scene_id = scene_id
	get_tree().call_deferred("change_scene_to_file", SCENES[scene_id])

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

func get_current_scene_id() -> SceneID:
	var current_path := get_tree().current_scene.scene_file_path
	for id in SCENES:
		if SCENES[id] == current_path:
			return id	
	return current_scene_id 
