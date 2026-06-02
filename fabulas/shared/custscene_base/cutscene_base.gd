class_name CutsceneBase
extends Node

@export var next_scene: String = ""
var slides: Array = []
var current_index: int = 0

@onready var texture_rect = $CanvasLayer/TextureRect
@onready var label = $CanvasLayer/Panel/Label
@onready var color_rect = $CanvasLayer/ColorRect
@onready var anim = $AnimationPlayer

func _ready() -> void:
	anim.animation_finished.connect(_on_animation_finished)
	_load_slide(0)
	anim.play("slide_transition")

func _load_slide(index: int) -> void:
	var slide = slides[index]

	texture_rect.texture = slide["image"]
	label.text = slide["text"]

	anim.play("slide_transition") 

	SoundManager.play_voice(slide["voice"])

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "slide_transition":
		current_index += 1
		if current_index >= slides.size():
			_finish()
		else:
			_load_slide(current_index)
			anim.play("slide_transition")
	elif anim_name == "fade_out":
		get_tree().change_scene_to_file(next_scene)

func _finish() -> void:
	anim.play("fade_out")

func _play_voice(audio) -> void:
	if audio:
		pass

func _on_saltar_pressed() -> void:
	anim.stop()
	_finish()
