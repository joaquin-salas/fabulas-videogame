class_name Hurtbox
extends Area2D

## Clase que representa un área que recibe daño si entra en contacto con un [Hitbox].

# ====================== SIGNALS ========================
signal took_damage(amount: int, knockback_dir: Vector2)

# ********************** CALLBACKS **********************
func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var knockback_dir: Vector2 = (global_position - area.global_position).normalized()
		knockback_dir *= area.knockback_strength

		took_damage.emit(area.damage, knockback_dir)