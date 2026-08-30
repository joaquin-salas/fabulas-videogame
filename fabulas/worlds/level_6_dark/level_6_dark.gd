extends Node2D
@onready var marker_teleport_1: Marker2D = $"Teleport 1/MarkerTeleport1"
@onready var marker_teleport_2: Marker2D = $"Teleport 2/MarkerTeleport2"
@onready var marker_back: Marker2D = $MarkerBack
@onready var timer_fades: Timer = $TimerFades

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

  
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_teleport_1_body_entered(body: Node2D) -> void:
	TransitionsScreen.fade_out_not_paused()
	await get_tree().create_timer(0.5).timeout
	timer_fades.start()
	body.global_position = marker_teleport_1.global_position

func _on_teleport_back_body_entered(body: Node2D) -> void:
	TransitionsScreen.fade_out_not_paused()
	await get_tree().create_timer(0.5).timeout
	timer_fades.start()
	body.global_position = marker_back.global_position
	
func _on_timer_fades_timeout() -> void:
	TransitionsScreen.fade_in()


func _on_teleport_2_body_entered(body: Node2D) -> void:
	TransitionsScreen.fade_out_not_paused()
	await get_tree().create_timer(0.5).timeout
	timer_fades.start()
	body.global_position = marker_teleport_2.global_position
