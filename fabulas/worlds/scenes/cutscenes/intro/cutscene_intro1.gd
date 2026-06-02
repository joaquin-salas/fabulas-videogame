extends CutsceneBase

func _ready() -> void:
	next_scene = "res://worlds/scenes/level_1/level_1.tscn"
	slides = [
		{
			"image": load("res://worlds/scenes/cutscenes/intro/art/1.png"),
			"text": " ",
			"voice": "VozIntro1",
			"duration": 8.0
		},
		{
			"image": load("res://worlds/scenes/cutscenes/intro/art/2.png"),
			"text": " ",
			"voice":  "VozIntro2",
			"duration": 13.0
		},
		{
			"image": load("res://worlds/scenes/cutscenes/intro/art/3.png"),
			"text": " ",
			"voice": "VozIntro3",
			"duration": 14.0
		},
		{
			"image": load("res://worlds/scenes/cutscenes/intro/art/4.png"),
			"text": " ",
			"voice": "VozIntro4",
			"duration": 10.0
		},
		{
			"image": load("res://worlds/scenes/cutscenes/intro/art/5.png"),
			"text": " ",
			"voice": "VozIntro5",
			"duration": 10.0
		},
	]
	super._ready()
