extends Hitbox

## Explosion that extends [Hitbox] and applies knockback to the player when it collides with its [Hurtbox].

# ====================== REFERENCE VARIABLES ======================
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var explosion_particles: GPUParticles2D = $ExplosionParticles

# *********************** BUILT IN CALLBACKS **********************
func _ready() -> void:
	SoundManager.play_sfx("Explosion")
	explosion_particles.emitting = true

	# Permitimos que el motor físico procese la colisión durante un fotograma.
	# Esto garantiza que la señal nativa area_entered de la Hurtbox pueda detectarlo
	await get_tree().physics_frame
	
	collision_shape_2d.set_deferred("disabled", true)

	await explosion_particles.finished
	
	queue_free()