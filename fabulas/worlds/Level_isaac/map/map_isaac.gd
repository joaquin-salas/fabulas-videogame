extends Node2D

@onready var pink: ColorRect = $pink
@onready var black: ColorRect = $black
@onready var timerblack: Timer =$LevelOfTimer/Timerblack
@onready var timernoblack: Timer =$LevelOfTimer/Timernoblack

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




func _on_timernoblack_timeout() -> void:
	black.visible = true
	timerblack.start()

func _on_timerblack_timeout() -> void:
	black.visible = false
	timernoblack.start()


func _on_timerstart_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		timernoblack.start()
		black.visible = false	


func _on_timer_stop_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		timerblack.stop()
		timernoblack.stop()
		black.visible = true
