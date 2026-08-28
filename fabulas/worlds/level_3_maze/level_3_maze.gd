extends Node2D
var whitekey : bool = true
var bluekey : bool = true
var redkey : bool = false


@onready var blue_key: Node2D = $BluePart/BlueKey
@onready var white_key: Node2D = $WhitePart/WhiteKey

@onready var bluedoor: TileMapLayer = $BluePart/Bluedoor

@onready var whitedoor: TileMapLayer = $WhitePart/Whitedoor

@onready var black_rect: Node = $BluePart/BlackRect
@onready var black_circle: Sprite2D = $"../Player/blackCircle"

@onready var timer: Timer = $DarkPart/Timer




func _ready() -> void:
	SignalBus.bluekeytake.connect(_on_blue_key_taken)
	SignalBus.whitekeytake.connect(_on_white_key_take)

func _on_blue_key_taken() -> void:
	bluekey = true
	print(bluekey)
	SoundManager.play_sfx("Key")

func _on_white_key_take() -> void:
	whitekey = true
	print(whitekey)
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
		timer.start()

func _on_timer_timeout() -> void:
	black_circle.visible = true



func _on_white_door_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and whitekey == true:
		whitedoor.clear()
		SoundManager.play_sfx("Door")
		whitekey = false
