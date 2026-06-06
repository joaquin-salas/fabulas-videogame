extends Node


func _ready() -> void:
	SoundManager.stop_voice()
	SoundManager.play_music("Musica2")
