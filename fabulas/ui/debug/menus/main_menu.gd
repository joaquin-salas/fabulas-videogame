extends "res://ui/debug/base_menu/base_menu.gd"


func on_accept():

	match selected_index:

		0:
			get_parent().show_menu("CheatsMenu")

		1:
			get_parent().show_menu("SceneMenu")

		2:
			get_parent().show_menu("VisualMenu")

		3:
			get_parent().show_menu("InfoMenu")
