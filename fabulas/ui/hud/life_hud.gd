extends CanvasLayer

## Script for the life HUD, which displays the player's health

# ====================== REFERENCE VARIABLES ======================
@onready var heart_box_container: HBoxContainer = $HeartBoxContainer

# ====================== RESOURCES ======================
const HEART_TEXTURE_IMAGE: Resource = preload("res://assets/ui/heart.png")

# ************************ CALLBACKS ************************
func _ready() -> void:
	SignalBus.player_max_health_set.connect(_on_player_max_health_set)
	SignalBus.player_health_changed.connect(_on_player_health_changed)

# ******************* SIGNALS CALLBACKS *******************
func _on_player_max_health_set(max_health: int) -> void:
	# Clear existing heart images
	for heart_child in heart_box_container.get_children():
		heart_child.queue_free()

	for i in max_health:
		var new_heart := TextureRect.new() # Create a new TextureRect node
		new_heart.texture = HEART_TEXTURE_IMAGE # Set the heart texture to the new TextureRect node

		new_heart.custom_minimum_size = Vector2(100, 100)
		new_heart.pivot_offset = Vector2(50, 50)

		heart_box_container.add_child(new_heart) # Add the new TextureRect node to the heart_box_container

		# Tween to animate a heart beat effect
		var tween := create_tween().set_loops().bind_node(new_heart)

		tween.tween_property(new_heart, "scale", Vector2(1.1, 1.1), 0.5).set_trans(Tween.TRANS_SINE)
		tween.tween_property(new_heart, "scale", Vector2(1.0, 1.0), 0.6).set_trans(Tween.TRANS_SINE)

func _on_player_health_changed(new_health: int) -> void:
	var heart_childs := heart_box_container.get_children()
	print("Heart childs: ", heart_childs)

	for i in heart_childs.size():
		print("Updating heart ", i, " to ", new_health)
		if i < new_health:
			heart_childs[i].show()
		else:
			heart_childs[i].hide()
