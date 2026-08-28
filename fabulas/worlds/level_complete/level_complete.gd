extends Node2D

@onready var keys_hud: CanvasLayer = $CanvasLayer/KeysHud


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		TransitionsScreen.fade_in()
		SignalBus.hud_off.connect(_on_hud_off)
		SignalBus.hud_on.connect(_on_hud_on)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_hud_off() :
	keys_hud.visible = false
	
func _on_hud_on() :
	keys_hud.visible = true
