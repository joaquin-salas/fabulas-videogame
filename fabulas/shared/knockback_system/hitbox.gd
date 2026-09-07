class_name Hitbox
extends Area2D

## Area that inflicts a knockback force when it collides with a [Hurtbox]

# ====================== EXPORT VARIABLES ======================
## The strength of the knockback force applied to the [Hurtbox] upon collision.
@export var knockback_strength: float = 400.0
## The maximum angle (in degrees) at which the knockback can launch the player upwards.
@export var max_launch_angle: float = 45.0 
## If true, the knockback will be blocked by walls. If false, the knockback will ignore walls and push the player through them.
@export var blocked_by_walls: bool = false
