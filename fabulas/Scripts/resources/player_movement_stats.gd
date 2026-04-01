class_name PlayerMovementStats extends Resource

## Variables para controlar el movimiento del Player

@export_category("Movement")
@export var speed_floor: float = 300.0
@export var speed_air: float = 200.0
@export var jump_force: float = -300.0

@export_category("Gravity")
@export var jump_gravity: float = 980.0
@export var fall_gravity: float = 1400.0

@export_category("Jump")
@export_range(0.0, 1.0, 0.025) var variable_jump_multiplier: float = 0.5
