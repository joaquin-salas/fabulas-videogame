extends CanvasLayer
@onready var blue_box: TextureRect = $HBoxContainer/Box/blueBox
@onready var white_box: TextureRect = $HBoxContainer/Box/whiteBox
@onready var purple_box: TextureRect = $HBoxContainer/Box/purpleBox

const GREEN_TICK = preload("uid://cm3vin606adno")


func _ready() -> void:
	SignalBus.blue_key_take.connect(_on_blue_key_taken)
	SignalBus.white_key_take.connect(_on_white_key_take)
	SignalBus.purple_key_take.connect(_on_purple_key_take)

func _on_blue_key_taken() -> void:
	SoundManager.play_sfx("Key")
	blue_box.texture = GREEN_TICK

func _on_white_key_take() -> void:
	SoundManager.play_sfx("Key")
	white_box.texture = GREEN_TICK
	
func _on_purple_key_take() -> void:
	SoundManager.play_sfx("Key")
	purple_box.texture = GREEN_TICK
