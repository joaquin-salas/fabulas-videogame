extends Node2D

	
@onready var bridge: TileMapLayer = $CentrePart/Bridge




var lever_paths: Dictionary = {
	0: [Vector2i(-29, -37), Vector2i(-28, -37),Vector2i(-27,  -37)],
	1: [Vector2i(-26, -37), Vector2i(-25, -37),Vector2i(-24,  -37)],
	2: [Vector2i(-23, -37), Vector2i(-22, -37),Vector2i(-21,  -37)],
	3: [Vector2i(-20, -37), Vector2i(-19, -37),Vector2i(-18,  -37)],
	4: [Vector2i(-17, -37), Vector2i(-16, -37),Vector2i(-15,  -37)],
	5: [Vector2i(-14, -37), Vector2i(-13, -37),Vector2i(-12,  -37)],
	6: [Vector2i(-11, -37), Vector2i(-10, -37),Vector2i(-9,  -37)],
	7: [Vector2i(-8, -37), Vector2i(-7, -37),Vector2i(-6,  -37), Vector2i(-5, -37), Vector2i(-4, -37)],
}

@export var path_source_id: int = 0
@export var path_atlas_coords: Vector2i = Vector2i(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.lever_toggled.connect(_on_lever_toggled)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_lever_toggled(lever_id: int, is_on: bool) -> void:
	if not lever_paths.has(lever_id):
		return
	
	for cell in lever_paths[lever_id]:
		if is_on:
			bridge.set_cell(cell, path_source_id, path_atlas_coords)
		else:
			pass
