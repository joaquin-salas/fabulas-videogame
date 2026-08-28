@tool
extends StaticBody2D

## A temporary platform where the player can stand on for a limited time before it desappears.

# ====================== EXPORT VARIABLES ======================
@export_category("Platform Visuals")
@export var platform_frames: SpriteFrames:
	set(value):
		platform_frames = value
		if is_node_ready() and Engine.is_editor_hint():
			_update_visual_and_collision()

@export var particles_texture: Texture2D:
	set(value):
		particles_texture = value
		# Actualizamos al instante en el editor cuando arrastras la imagen[cite: 1]
		if is_node_ready() and Engine.is_editor_hint():
			_update_visual_and_collision()

@export_category("Platform Behaviour")
@export var crumbling_time: float = 1.5
@export var recovery_time: float = 2.0

# ====================== REFERENCE VARIABLES ======================
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var trigger_area_2d: Area2D = $TriggerArea2D
@onready var trigger_collision_shape_2d: CollisionShape2D = $TriggerArea2D/CollisionShape2D
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
@onready var crumbling_timer: Timer = $Timers/CrumblingTimer
@onready var recovery_timer: Timer = $Timers/RecoveryTimer
@onready var broken_particles: GPUParticles2D = $Particles/BrokenParticles
@onready var recovery_particles: GPUParticles2D = $Particles/RecoveryParticles

# *********************** BUILT IN CALLBACKS **********************
func _ready() -> void:
	assert(platform_frames != null, "Platform frames are missing!")

	_update_visual_and_collision()

	if Engine.is_editor_hint():
		return

	animated_sprite_2d.play("idle")
	crumbling_timer.wait_time = crumbling_time
	recovery_timer.wait_time = recovery_time

	# Connect signals
	trigger_area_2d.body_entered.connect(_on_trigger_area_2d_body_entered)
	crumbling_timer.timeout.connect(_on_crumbling_timer_timeout)
	recovery_timer.timeout.connect(_on_recovery_timer_timeout) 

# ******************* PRIVATE FUNCTIONS *******************
func _update_visual_and_collision() -> void:
	if platform_frames == null:
		return
		
	animated_sprite_2d.sprite_frames = platform_frames
	
	var texture: Texture2D = platform_frames.get_frame_texture("idle", 0)
	if texture == null:
		return
	var size: Vector2 = texture.get_size()
	
	if collision_shape_2d.shape == null:
		collision_shape_2d.shape = RectangleShape2D.new()
	collision_shape_2d.shape.size = size
	
	if trigger_collision_shape_2d.shape == null:
		trigger_collision_shape_2d.shape = RectangleShape2D.new()
		
	# Place the trigger above the platform
	trigger_collision_shape_2d.shape.size = Vector2(size.x - 4.0, 2.0)
	trigger_collision_shape_2d.position.y = -(size.y / 2) - 2.0

	# 5. Asignamos la textura a las partículas
	if particles_texture != null:
		broken_particles.texture = particles_texture
		recovery_particles.texture = particles_texture

# ******************* SIGNALS CALLBACKS *******************
func _on_trigger_area_2d_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if crumbling_timer.is_stopped():
			crumbling_timer.start()

			var custom_speed = 1.0 / crumbling_timer.wait_time
			animated_sprite_2d.play("crumbling", custom_speed)

			SoundManager.play_sfx("Crumbling", -4.0)

			var shake_tween = create_tween()
			shake_tween.bind_node(self)
			var original_y = animated_sprite_2d.position.y
			shake_tween.tween_property(animated_sprite_2d, "position:y", original_y + 8.0, 0.05)
			shake_tween.tween_property(animated_sprite_2d, "position:y", original_y, 0.05)

func _on_crumbling_timer_timeout() -> void:
	SoundManager.play_sfx("Broken", -4.0)

	animated_sprite_2d.hide()
	collision_shape_2d.set_deferred("disabled", true)
	trigger_area_2d.set_deferred("monitoring", false)

	broken_particles.emitting = true
	
	recovery_timer.start()

func _on_recovery_timer_timeout() -> void:
	SoundManager.play_sfx("Recovery", -4.0)
	
	recovery_particles.emitting = true
	await recovery_particles.finished

	animated_sprite_2d.show()
	animated_sprite_2d.position.y = 0.0
	animated_sprite_2d.play("idle")

	recovery_particles.emitting = false
	broken_particles.emitting = false

	collision_shape_2d.set_deferred("disabled", false)
	trigger_area_2d.set_deferred("monitoring", true)
