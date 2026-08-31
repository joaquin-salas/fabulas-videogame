extends Node2D
var current_scene: SceneManager.SceneID
var checkpoint_active_name : String
var checkpoint_active: bool = false
var checkpoint_position: Vector2

func _ready() -> void:
	SignalBus.checkpoint_activated.connect(_on_checkpoint_activated)
	load_checkpoint()


func _on_checkpoint_activated(checkpoint_name: String, position_checkpoint: Vector2):
	checkpoint_active_name = checkpoint_name
	checkpoint_position = position_checkpoint
	checkpoint_active = true
	current_scene = SceneManager.get_current_scene_id()

	print("CHECKPOINT ACTIVADO")
	print("active: ", checkpoint_active)
	print("scene: ", current_scene)

	save_checkpoint()

func save_checkpoint() -> void:

	var data := {
		"checkpoint_active": checkpoint_active,
		"checkpoint_name": checkpoint_active_name,
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
		checkpoint_active_name = data["checkpoint_name"]
		checkpoint_active = data["checkpoint_active"]
		checkpoint_position.x = data["position"]["x"]
		checkpoint_position.y = data["position"]["y"]
		current_scene = int(data["current_scene"]) as SceneManager.SceneID
		
		
		
func clear_checkpoint() -> void:
	checkpoint_active = false
	checkpoint_active_name = ""
	checkpoint_position = Vector2.ZERO
	current_scene = SceneManager.SceneID.MAIN_MENU 

	if FileAccess.file_exists("user://checkpoints.save"):
		DirAccess.remove_absolute("user://checkpoints.save")

	print("CHECKPOINT LIMPIADO")
