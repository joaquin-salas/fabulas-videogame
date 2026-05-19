extends Button
class_name  CustomButton

@onready var audio_click: AudioStreamPlayer = $AudioClick
@onready var audio_enter: AudioStreamPlayer = $AudioEnter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	audio_click.play()


func _on_mouse_entered() -> void:
	audio_enter.play()
