extends Area2D

@onready var win_label: Label = $Win

func _ready() -> void:
	self.body_entered.connect(_on_area_2d_body_entered)	
	
	win_label.hide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		win_label.show()
