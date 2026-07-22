extends Control

@onready var option_list: VBoxContainer = $VBoxContainer

var options: Array = []
var selected_index := 0

func _ready():
	options.assign(option_list.get_children())
	if options.size() > 0:
		options[selected_index].select()

func _unhandled_input(event):
	if not visible or not DebugMenu.is_open:
		return
	if event.is_action_pressed("ui_down"):
		_move_selection(1)
	elif event.is_action_pressed("ui_up"):
		_move_selection(-1)
	elif event.is_action_pressed("ui_accept"):
		on_accept()
	elif event.is_action_pressed("ui_cancel"):
		on_back()

func _move_selection(direction: int):
	options[selected_index].deselect()
	selected_index = wrapi(selected_index + direction, 0, options.size())
	options[selected_index].select()

func on_accept():
	options[selected_index].activate()

func on_back():
	get_parent().show_menu("MainMenu")
