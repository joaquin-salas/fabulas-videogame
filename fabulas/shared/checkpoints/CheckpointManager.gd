extends Node

# variable for id of the chekpoint
var activated_checkpoint_id: String = ""
# Path to store the save file on the user's device
const SAVE_PATH := "user://checkpoint.save"

# Current active scene
var current_scene_id: SceneManager.SceneID = SceneManager.SceneID.MAIN_MENU

# Positions: respawn for death, saved_position for quitting mid-game
var respawn_position: Vector2 = Vector2.ZERO 
var saved_position: Vector2 = Vector2.ZERO 

# Checkpoint state and health tracking
var has_checkpoint: bool = false
var saved_health: int = 3

func _ready() -> void:
	# Listen for health updates and load saved data on start
	SignalBus.player_health_changed.connect(_on_player_health_changed)
	load_checkpoint()

# Updates current player position and health before saving
func update_player_data_before_save() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player and is_instance_valid(player):
		saved_position = player.global_position
		saved_health = player.current_health

# Keeps track of player health in real time  
func _on_player_health_changed(new_health: int) -> void:
	if new_health > 0:
		saved_health = new_health

# Sets a new checkpoint when the player activates one
func set_checkpoint(scene_id: SceneManager.SceneID, pos: Vector2, current_health: int = 3, id: String = "") -> void:
	current_scene_id = scene_id
	respawn_position = pos
	saved_position = pos 
	has_checkpoint = true
	saved_health = current_health
	activated_checkpoint_id = id
	
	save_checkpoint()

# Resets health to 3 and teleports player to checkpoint on death
func on_player_died() -> void:
	saved_health = 3 
	saved_position = respawn_position 
	save_checkpoint()

# Deletes the checkpoint data and save file
func clear_checkpoint() -> void:
	has_checkpoint = false
	current_scene_id = SceneManager.SceneID.MAIN_MENU
	respawn_position = Vector2.ZERO
	saved_position = Vector2.ZERO
	saved_health = 3
	
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)

# Saves data to a JSON file
func save_checkpoint() -> void:
	if not has_checkpoint:
		return
		
	var data := {
		"scene_id": current_scene_id,
		"pos_x": respawn_position.x,
		"pos_y": respawn_position.y,
		"saved_pos_x": saved_position.x,
		"saved_pos_y": saved_position.y,
		"has_checkpoint": has_checkpoint,
		"health": saved_health,
		"activated_checkpoint_id": activated_checkpoint_id
	}
	
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(data))
		file.close()

# Loads data from the file
func load_checkpoint() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
		
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_text := file.get_as_text()
		file.close()
		
		var data = JSON.parse_string(json_text)
		if data is Dictionary:
			current_scene_id = int(data.get("scene_id", SceneManager.SceneID.MAIN_MENU))
			respawn_position = Vector2(data.get("pos_x", 0), data.get("pos_y", 0))
			saved_position = Vector2(data.get("saved_pos_x", respawn_position.x), data.get("saved_pos_y", respawn_position.y))
			has_checkpoint = data.get("has_checkpoint", false)
			saved_health = int(data.get("health", 3))
			activated_checkpoint_id = data.get("activated_checkpoint_id", "")
