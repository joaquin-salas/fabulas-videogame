extends Node2D
var whitekey : bool = false
var bluekey : bool = true
var redkey : bool = false

@onready var blue_key: Node2D = $BlueKey
@onready var white_key: Node2D = $WhiteKey
@onready var bluedoor: TileMapLayer = $BluePart/Bluedoor

@onready var black_rect: Node = $BluePart/BlackRect
@onready var black_circle: Sprite2D = $Player/blackCircle





func _ready() -> void:
	SignalBus.bluekeytake.connect(_on_blue_key_taken)

func _on_blue_key_taken() -> void:
	bluekey = true
	print(bluekey)
	SoundManager.play_sfx("Key")


func _on_door_blue_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and bluekey == true:
		bluedoor.clear()
		SoundManager.play_sfx("Door")
		bluekey = false
	
func _on_change_part_body_entered(body: Node2D) -> void:
	$BluePart/ChangePart.set_deferred("monitoring", false)
	black_rect.queue_free()


func _on_black_circle_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		black_circle.visible = true
	
