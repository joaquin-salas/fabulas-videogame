extends Node

@onready var puerta: Area2D = $"../puerta"

func _ready() -> void:
	SoundManager.stop_voice()
	SoundManager.play_music("Musica2")



func _on_puerta_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneManager.goto(SceneManager.SceneID.LEVEL_1)
