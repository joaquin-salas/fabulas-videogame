extends Area2D

@export var checkpoint_id: String = ""
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var _activated: bool = false

func _ready() -> void:
	if CheckpointManager.activated_checkpoint_id == checkpoint_id:
		_activated = true
		animated_sprite_2d.play("green")
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not _activated:
		_activated = true
		var current_health: int = 3
		if "current_health" in body:
			current_health = body.current_health
		CheckpointManager.set_checkpoint(
			SceneManager.get_current_scene_id(), 
			global_position, 
			current_health,
			checkpoint_id
		)
		
		animated_sprite_2d.play("green")
		SoundManager.play_sfx("CheckPoint")
