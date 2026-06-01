extends CutsceneBase

func _ready() -> void:
	next_scene = "res://worlds/scenes/level_1/level_1.tscn"
	slides = [
		{
			"image": null,
			"text": "Hace mil años el reino prosperaba...",
			"voice": null,
			"duration": 4.0
		},
		{
			"image": null,
			"text": "Hasta que la oscuridad llegó.",
			"voice": null,
			"duration": 3.0
		},
	]
	super._ready()
