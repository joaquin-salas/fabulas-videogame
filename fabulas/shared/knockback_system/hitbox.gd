class_name Hitbox
extends Area2D

## Area that inflicts a knockback force when it collides with a [Hurtbox]

# ====================== EXPORT VARIABLES ======================
@export var knockback_strength: float = 400.0
@export var max_launch_angle: float = 45.0 # Max knockback angle
