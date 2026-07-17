extends Node2D

var direction: Vector2 = Vector2.ZERO
@export var speed: float = 500.0

func _physics_process(delta):
	global_position += direction * speed * delta

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("physics"):
		queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		queue_free()
