class_name Hurtbox
extends Area2D

## Clase que representa un área que recibe daño si entra en contacto con un [Hitbox].

# ====================== CUSTOM SIGNALS ========================
signal took_knockback(knockback_dir: Vector2)

# ********************** BUILT IN CALLBACKS **********************
func _ready() -> void:
	self.area_entered.connect(_on_area_entered)

# ********************** PRIVATE METHODS **********************
## Calculates the knockback direction based on the relative position of the collision.
## It prevents infinite vertical bouncing (pogo effect) by clamping the upward launch angle 
## to the Hitbox's defined max_launch_angle, forcing the player outwards.
func _calculate_direction(hitbox: Hitbox) -> Vector2:
	# Get the natural impact vector
	var knockback_dir: Vector2 = (global_position - hitbox.global_position).normalized()
	
	# Intervene only if the vector points upwards
	if knockback_dir.y < 0:
		var current_angle: float = knockback_dir.angle()
		var max_angle_rad: float = deg_to_rad(hitbox.max_launch_angle)
		
		# Check which side we are on to apply the clamp correctly
		if knockback_dir.x >= 0:
			# Top-right quadrant (0 to -90 degrees). 
			# Clamp so the angle doesn't go below -max_launch_angle.
			current_angle = max(current_angle, -max_angle_rad)
		else:
			# Top-left quadrant (-180 to -90 degrees).
			# Clamp so the angle doesn't go above -135 degrees (-180 + 45).
			current_angle = min(current_angle, -PI + max_angle_rad)
		
		# Reconstruct the directional vector with the clamped angle
		knockback_dir = Vector2.RIGHT.rotated(current_angle)
		
	return knockback_dir
	
# ********************** SIGNALS CALLBACK **********************
func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var knockback_dir: Vector2 = _calculate_direction(area)
		
		# Add the force and emit the signal
		knockback_dir *= area.knockback_strength
		took_knockback.emit(knockback_dir)