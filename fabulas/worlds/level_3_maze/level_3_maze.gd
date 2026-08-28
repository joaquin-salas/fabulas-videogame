extends Node2D
var whitekey : bool = false
var bluekey : bool = false
var purplekey : bool = false


@onready var blue_key: Node2D = $BluePart/BlueKey
@onready var white_key: Node2D = $WhitePart/WhiteKey
@onready var purple_key: Node2D = $PurplePart/purpleKey

@onready var bluedoor: TileMapLayer = $BluePart/Bluedoor
@onready var purpledoor: TileMapLayer = $PurplePart/purpleDoor
@onready var whitedoor: TileMapLayer = $WhitePart/Whitedoor

@onready var black_rect: Node = $BluePart/BlackRect
@onready var black_circle: Sprite2D = $"../Player/blackCircle"
@onready var timer: Timer = $PurplePart/Timer




func _ready() -> void:
	SignalBus.blue_key_take.connect(_on_blue_key_taken)
	SignalBus.white_key_take.connect(_on_white_key_take)
	SignalBus.purple_key_take.connect(_on_purple_key_take)




func _on_blue_key_taken() -> void:
	bluekey = true
	SoundManager.play_sfx("Key")

func _on_white_key_take() -> void:
	whitekey = true
	SoundManager.play_sfx("Key")
	
func _on_purple_key_take() -> void:
	purplekey = true
	SoundManager.play_sfx("Key")







func _on_door_blue_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and bluekey == true:
		bluedoor.clear()
		SoundManager.play_sfx("Door")
		bluekey = false
	
func _on_white_door_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and whitekey == true:
		whitedoor.clear()
		SoundManager.play_sfx("Door")
		whitekey = false
	
func _on_purple_door_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and purplekey == true:
		purpledoor.clear()
		SoundManager.play_sfx("Door")
		purplekey = false




func _on_change_part_body_entered(body: Node2D) -> void:
	$BluePart/ChangePart.set_deferred("monitoring", false)
	black_rect.queue_free()


func _on_black_circle_zone_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		timer.start()

func _on_timer_timeout() -> void:
	black_circle.visible = true




func _on_area_on_body_entered(body: Node2D) -> void:
	SignalBus.hud_on.emit()


func _on_area_off_body_entered(body: Node2D) -> void:
	SignalBus.hud_off.emit()
