extends CutsceneBase

func _ready() -> void:
	SoundManager.play_music("Intro1")
	next_scene = "res://worlds/scenes/level_2/level_2.tscn"
	slides = [
		{
			"image": load("res://worlds/scenes/cutscenes/intro/art1/1.png"),
			"text": " ",
			"voice": "VozIntro1",
			"duration": 8.0
		},
		{
			"image": load("res://worlds/scenes/cutscenes/intro/art1/2.png"),
			"text": " ",
			"voice":  "VozIntro2",
			"duration": 13.0
		},
		{
			"image": load("res://worlds/scenes/cutscenes/intro/art1/3.png"),
			"text": " ",
			"voice": "VozIntro3",
			"duration": 14.0
		},
		{
			"image": load("res://worlds/scenes/cutscenes/intro/art1/4.png"),
			"text": " ",
			"voice": "VozIntro4",
			"duration": 10.0
		},
		{
			"image": load("res://worlds/scenes/cutscenes/intro/art1/5.png"),
			"text": " ",
			"voice": "VozIntro5",
			"duration": 10.0
		},
	]
	super._ready()
