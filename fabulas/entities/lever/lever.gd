extends Node2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var exclamation: Sprite2D = $Exclamation
@onready var interact_icon: AnimatedSprite2D = $InteractIcon

@export var lever_id: int = 0
var player_in_range: bool = false
var is_on: bool = false

func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if player_in_range and event.is_action_pressed("interact"):
		is_on = !is_on
		if is_instance_valid(exclamation):
			exclamation.queue_free()
		SoundManager.play_sfx("Lever")
		
		SignalBus.lever_toggled.emit(lever_id, is_on)
		sprite_2d.play("ON" if is_on else "OFF")

func _on_area_lever_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		interact_icon.visible = true
		interact_icon.play("gamepad" if InputDeviceManager.is_using_gamepad else "keyboard")
		player_in_range = true


func _on_area_lever_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		interact_icon.visible = false
		player_in_range = false
