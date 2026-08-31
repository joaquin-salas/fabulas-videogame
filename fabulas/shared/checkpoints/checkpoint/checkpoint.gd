extends Area2D


@export var checkpoint_name: String = ""
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var position_checkpoint: Vector2 = global_position

var activated: bool = false

func _ready() -> void:
	pass
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not activated:
		activated = true
		SignalBus.checkpoint_activated.emit(checkpoint_name, global_position)
		animated_sprite_2d.play("green")
		SoundManager.play_sfx("CheckPoint")
