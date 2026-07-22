extends HBoxContainer

signal toggled(value: bool)

@onready var arrow_label = $ArrowLabel
@onready var name_label = $NameLabel
@onready var value_label = $ValueLabel

@export var option_id: String = ""
var state := false

func _ready():
	deselect()

func select():
	arrow_label.text = "▶"

func deselect():
	arrow_label.text = ""

func set_option_name(text: String):
	name_label.text = text

func set_value(text: String):
	value_label.text = text

func set_toggle(new_state: bool):
	state = new_state
	if state:
		value_label.text = "ON"
		value_label.modulate = Color.GREEN
	else:
		value_label.text = "OFF"
		value_label.modulate = Color.RED

func activate():
	set_toggle(!state)
	toggled.emit(state)
