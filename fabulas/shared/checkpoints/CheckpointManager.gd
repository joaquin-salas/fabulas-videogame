extends Node2D
var current_scene: SceneManager.SceneID

var checkpoint_active: bool = false
var checkpoint_position: Vector2

func _ready() -> void:
	SignalBus.checkpoint_activated.connect(_on_checkpoint_activated)
	load_checkpoint()


func _on_checkpoint_activated(position_checkpoint: Vector2):
	checkpoint_position = position_checkpoint
	checkpoint_active = true
	current_scene = SceneManager.get_current_scene_id()
	save_checkpoint()

func save_checkpoint() -> void:

	var data := {
		"checkpoint_active": checkpoint_active,
		"position": {"x": checkpoint_position.x, "y": checkpoint_position.y},
		"current_scene": current_scene
	}
	var json_string := JSON.stringify(data)
	var file := FileAccess.open("user://checkpoints.save", FileAccess.WRITE)
	file.store_string(json_string)
	file.close()
 
func load_checkpoint():
	if not FileAccess.file_exists("user://checkpoints.save"):
		return
	else:
		var file := FileAccess.open("user://checkpoints.save", FileAccess.READ)
		var json_string := file.get_as_text()
		file.close()
		var data = JSON.parse_string(json_string)
		checkpoint_active = data["checkpoint_active"]
		checkpoint_position.x = data["position"]["x"]
		checkpoint_position.y = data["position"]["y"]
		current_scene = int(data["current_scene"]) as SceneManager.SceneID
		
		
		
func clear_checkpoint() -> void:
	checkpoint_active = false
	checkpoint_position = Vector2.ZERO
	current_scene = SceneManager.SceneID.MAIN_MENU 

	if FileAccess.file_exists("user://checkpoints.save"):
		DirAccess.remove_absolute("user://checkpoints.save")
