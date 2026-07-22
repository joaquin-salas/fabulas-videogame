extends Node

@onready var puerta: Area2D = $"../puerta"

func _ready() -> void:
	SoundManager.stop_voice()
	SoundManager.play_music("Musica2")



func _on_puerta_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		TransitionsScreen.fade_out()
		await TransitionsScreen.on_faded_out
		SceneManager.goto(SceneManager.SceneID.LEVEL_2)
		TransitionsScreen.fade_in()
