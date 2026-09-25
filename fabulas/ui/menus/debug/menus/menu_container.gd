extends Control


@onready var menus = {
	"MainMenu": $MainMenu,
	"CheatsMenu": $CheatsMenu,
	"SceneMenu": $SceneMenu,
	"VisualMenu": $VisualMenu,
	"InfoMenu": $InfoMenu
}


func _ready():
	show_menu("MainMenu")


func show_menu(menu_name: String):

	for menu in menus.values():
		menu.visible = false

	menus[menu_name].visible = true
