extends CanvasLayer
## Autoload del menú de debug: guarda el estado de todos los cheats/toggles
## y avisa por señal a quien esté escuchando (HUD, jugador, enemigos...)

# ====================== SIGNALS ======================
signal collisions_visibility_changed(value: bool)
signal god_mode_changed(value: bool)
signal invincible_changed(value: bool)
signal info_panel_changed(value: bool)
signal heal_requested
signal kill_requested

# ====================== STATE ======================
var is_open := false

var show_collisions: bool = false:
	set(value):
		show_collisions = value
		collisions_visibility_changed.emit(value)

var god_mode: bool = false:
	set(value):
		god_mode = value
		god_mode_changed.emit(value)

var invincible: bool = false:
	set(value):
		invincible = value
		invincible_changed.emit(value)

var show_info_panel: bool = false:
	set(value):
		show_info_panel = value
		info_panel_changed.emit(value)

# ************************ CALLBACKS ************************
func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS  # sigue activo aunque el juego esté en pausa
	collisions_visibility_changed.connect(_on_collisions_visibility_changed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_menu"):
		toggle()

func _process(_delta: float) -> void:
	# mientras las colisiones estan visibles, ser refresca cada frame
	if show_collisions:
		_refresh_collision_shapes(get_tree().current_scene if get_tree().current_scene else get_tree().root)

# ******************* PUBLIC METHODS *******************
func toggle() -> void:
	is_open = !is_open
	get_tree().paused = is_open
	visible = is_open

func request_heal() -> void:
	heal_requested.emit()

func request_kill() -> void:
	kill_requested.emit()

# ******************* SIGNAL CALLBACKS *******************
func _on_collisions_visibility_changed(value: bool) -> void:
	get_tree().debug_collisions_hint = value
	_refresh_collision_shapes(get_tree().root)

# ******************* PRIVATE METHODS *******************
func _refresh_collision_shapes(node: Node) -> void:
	if node is CollisionShape2D or node is CollisionPolygon2D:
		node.queue_redraw()
	for child in node.get_children():
		_refresh_collision_shapes(child)
