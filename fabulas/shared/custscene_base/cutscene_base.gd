class_name CutsceneBase
extends Node

@export var next_scene: String = ""
var slides: Array = []
var current_index: int = 0

@onready var texture_rect = $CanvasLayer/TextureRect
@onready var label = $CanvasLayer/Panel/Label
@onready var color_rect = $CanvasLayer/ColorRect
@onready var anim = $AnimationPlayer
@onready var timer: Timer = $Timer


func _ready() -> void:
	anim.animation_finished.connect(_on_animation_finished)
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	_load_slide(0)

func _load_slide(index: int) -> void:
	var slide = slides[index]
	texture_rect.texture = slide["image"]
	label.text = slide["text"]
	SoundManager.play_voice(slide["voice"])
	anim.play("slide_in")
	timer.wait_time = slide.get("duration", 5.0)
	timer.start()

func _on_timer_timeout() -> void:
	anim.play("slide_out")

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "slide_out":
		current_index += 1
		if current_index >= slides.size():
			_finish()
		else:
			_load_slide(current_index)
	elif anim_name == "fade_out":
		get_tree().change_scene_to_file(next_scene)

func _finish() -> void:
	timer.stop()
	anim.play("fade_out")

func _on_saltar_pressed() -> void:
	timer.stop()
	anim.stop()
	_finish()
