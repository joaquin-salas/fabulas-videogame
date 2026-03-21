class_name Player
extends CharacterBody2D

## Player movement configuration

# ====================== CONSTANT VARIABLES ======================

# ====================== REFERENCE VARIABLES ======================
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# ====================== EXPORT VARIABLES ======================
# Speed parameters
@export var speed_floor: float = 300.0
@export var speed_air: float = 200.0

# Jump parameters
@export var jump_force: float = -400.0

# ====================== INTERNAL VARIABLES ======================
var gravity: Vector2
var direction: float

# State Machine
enum STATE {
	IDLE,
	RUNNING,
	JUMPING,
	FALLING
}

var current_state: STATE = STATE.IDLE

# ******************* PRIVATE FUNCTIONS *******************
func print_debug(variables: Array) -> void:
	for i in variables:
		print(i)

func handle_animation() -> void:
	if direction < 0:
		animated_sprite_2d.flip_h = true
	elif direction > 0:
		animated_sprite_2d.flip_h = false

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity.y * delta

# ******************* CALLBACKS *******************
func _ready() -> void:
	gravity = (
		ProjectSettings.get_setting("physics/2d/default_gravity") * 
		ProjectSettings.get_setting("physics/2d/default_gravity_vector")
	)
	

func _physics_process(delta: float) -> void:
	
	handle_gravity(delta)
	direction = Input.get_axis("move_left", "move_right")
	
	match current_state:
		STATE.IDLE:
			velocity.x = 0
			animated_sprite_2d.play("idle")
			
			if direction != 0:
				current_state = STATE.RUNNING
			elif Input.is_action_just_pressed("jump"):
				current_state = STATE.JUMPING
		STATE.RUNNING:
			velocity.x = direction * speed_floor
			animated_sprite_2d.play("run")
			
			if Input.is_action_just_pressed("jump"):
				current_state = STATE.JUMPING
			elif direction == 0:
				current_state = STATE.IDLE
		STATE.JUMPING:
			if is_on_floor():
				velocity.y = jump_force
			velocity.x = direction * speed_air
			animated_sprite_2d.play("jump")
			
			if velocity.y > 0:
				current_state = STATE.FALLING
		STATE.FALLING:
			velocity.x = direction * speed_air
			animated_sprite_2d.play("fall")
			if is_on_floor():
				current_state = STATE.IDLE
	
	
	handle_animation()
	
	print_debug([gravity, direction])

	move_and_slide()
