extends CharacterBody2D

@export var player: CharacterBody2D
@export var Speed: int = 100
@export var Chase_Speed: int = 200
@export var Acceleration: int = 300
@export var Gravity: int = 980  # AÑADIDO: Gravedad

@onready var sprite = $Sprite2D
@onready var ray_cast: RayCast2D = $RayCast2D
@onready var timer = $Timer
@onready var animation_player = $AnimationPlayer  # AÑADIDO: Referencia al AnimationPlayer

var direction : Vector2
var right_bounds: Vector2
var left_bounds: Vector2

enum States {
	WANDER,
	CHASE
}

var current_state = States.WANDER

func _ready():
	left_bounds = self.position + Vector2(-120, 0)
	right_bounds = self.position + Vector2(120, 0)
	# AÑADIDO: Configuración inicial (enemigo mira a la derecha)
	direction = Vector2(1, 0)
	sprite.flip_h = false
	ray_cast.target_position = Vector2(125, 0)

func _physics_process(delta: float) -> void:
	# AÑADIDO: Aplicar gravedad
	if not is_on_floor():
		velocity.y += Gravity * delta
	
	handle_movement(delta)
	change_direction()
	look_for_player()
	move_and_slide()
	
	# AÑADIDO: Control de animaciones
	handle_animation()

func look_for_player():
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		if collider == player:
			chase_player()
		elif current_state == States.CHASE:
			stop_chase()
	elif current_state == States.CHASE:
		stop_chase()
		
func chase_player() -> void:
	timer.stop()
	current_state = States.CHASE
	
func stop_chase() -> void:
	if timer.time_left <= 0:
		timer.start()
		
func handle_movement(delta: float) -> void:
	if current_state == States.WANDER:
		velocity.x = move_toward(velocity.x, direction.x * Speed, Acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, direction.x * Chase_Speed, Acceleration * delta)

func change_direction() -> void:
	if current_state == States.WANDER:
		# Si mira a la derecha (NO está flippeado)
		if not sprite.flip_h:
			if self.position.x >= right_bounds.x:
				# Llegó al límite derecho, gira a la izquierda
				direction = Vector2(-1, 0)
				sprite.flip_h = true
				ray_cast.target_position = Vector2(-125, 0)
		# Si mira a la izquierda (está flippeado)
		else:
			if self.position.x <= left_bounds.x:
				# Llegó al límite izquierdo, gira a la derecha
				direction = Vector2(1, 0)
				sprite.flip_h = false
				ray_cast.target_position = Vector2(125, 0)
	else:
		# Modo CHASE: seguir al jugador
		direction = (player.position - self.position).normalized()
		
		if direction.x > 0:
			# Jugador está a la derecha
			sprite.flip_h = false
			ray_cast.target_position = Vector2(125, 0)
		else:
			# Jugador está a la izquierda
			sprite.flip_h = true
			ray_cast.target_position = Vector2(-125, 0)

# AÑADIDO: Función para manejar animaciones
func handle_animation() -> void:
	if is_on_floor() and abs(velocity.x) > 10:
		# Si está en el suelo y se mueve, reproducir walking
		if animation_player.current_animation != "Wallking":
			animation_player.play("Wallking")
	else:
		# Si está en el aire o quieto, detener animación
		animation_player.stop()

func _on_timer_timeout():
	current_state = States.WANDER
