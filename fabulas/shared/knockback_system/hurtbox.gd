class_name Hurtbox
extends Area2D

## Area that takes the knockback force when it collides with a [Hitbox]

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
	
## Casts a raycast to the hitbox to check if there is a wall blocking the line of sight.
## Returns true if the path is clear or if the hitbox ignores walls.
func _has_line_of_sight(hitbox: Hitbox) -> bool:
	if not hitbox.get("blocked_by_walls"):
		return true
		
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(hitbox.global_position, self.global_position)
	
	# Scan exclusively Layer 3 (World). The bit value is 1 << (3 - 1) = 4
	query.collision_mask = 4 
	
	var result = space_state.intersect_ray(query)
	
	return result.is_empty()

# ********************** SIGNAL CALLBACK **********************
func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		if not _has_line_of_sight(area):
			return
		
		var knockback_dir: Vector2 = _calculate_direction(area)
		
		# Add the force and emit the signal
		knockback_dir *= area.knockback_strength
		took_knockback.emit(knockback_dir)