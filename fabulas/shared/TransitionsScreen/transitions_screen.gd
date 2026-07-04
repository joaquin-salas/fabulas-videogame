extends CanvasLayer
@onready var color_rect: ColorRect = $ColorRect
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal on_faded_out   # pantalla en negra
signal on_faded_in    # pantalla transparente

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		on_faded_out.emit()
	elif anim_name == "fade_to_screen":
		color_rect.visible = false
		on_faded_in.emit()
		get_tree().paused = false

func fade_out():
	get_tree().paused = true
	color_rect.visible = true
	animation_player.play("fade_to_black")

func fade_in():
	animation_player.play("fade_to_screen")
