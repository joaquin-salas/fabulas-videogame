extends CanvasLayer

@onready var fps_label: Label = $PanelContainer/VBoxContainer/FPSLabel
@onready var state_label: Label = $PanelContainer/VBoxContainer/StateLabel
@onready var position_label: Label = $PanelContainer/VBoxContainer/PositionLabel
@onready var velocity_label: Label = $PanelContainer/VBoxContainer/VelocityLabel
@onready var memory_label: Label = $PanelContainer/VBoxContainer/MemoryLabel
@onready var objects_label: Label = $PanelContainer/VBoxContainer/ObjectsLabel

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = DebugMenu.show_info_panel
	DebugMenu.info_panel_changed.connect(_on_visibility_changed)

func _on_visibility_changed(value: bool) -> void:
	visible = value

func _process(_delta: float) -> void:
	if not visible:
		return

	var player := get_tree().get_first_node_in_group("player")

	fps_label.text = "FPS: %d (%.1f ms)" % [Engine.get_frames_per_second(), get_process_delta_time() * 1000.0]

	if player:
		state_label.text = "State: %s" % player.state_machine.current_state.name
		position_label.text = "Pos: (%.1f, %.1f)" % [player.global_position.x, player.global_position.y]
		velocity_label.text = "Vel: (%.1f, %.1f)" % [player.velocity.x, player.velocity.y]
	else:
		state_label.text = "State: -"
		position_label.text = "Pos: -"
		velocity_label.text = "Vel: -"

	var mem_mb: float = Performance.get_monitor(Performance.MEMORY_STATIC) / 1048576.0
	memory_label.text = "Mem: %.2f MB" % mem_mb
	objects_label.text = "Objects: %d | Nodes: %d | Draw calls: %d" % [
		Performance.get_monitor(Performance.OBJECT_COUNT),
		Performance.get_monitor(Performance.OBJECT_NODE_COUNT),
		Performance.get_monitor(Performance.RENDER_TOTAL_DRAW_CALLS_IN_FRAME)
	]
