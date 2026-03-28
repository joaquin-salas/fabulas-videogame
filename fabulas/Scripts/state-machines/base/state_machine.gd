class_name StateMachine
extends Node

## Clase encargada de manejar los estados (prepara los estados y cambia entre ellos)

## Nodo que se va a controlar
@onready var controlled_node: Node = self.owner

## Estado por defecto al iniciar la máquina de estados
@export var default_state: StateBase

## Estado activo en cada momento
var current_state: StateBase = null

func _ready() -> void:
	# Se llama a la función cuando todos los nodos han entrado en el SceneTree
	call_deferred("_start_default_state")

func _start_default_state() -> void:
	current_state = default_state
	_start_state()

## Prepara variables internas del estado activo y lanza su start
func _start_state() -> void:
	print('StateMachine en _start_state')
	print('controlled node: ' + controlled_node.name)
	print('Start state: ' + current_state.name)
	
	# Configuramos el estado
	current_state.controlled_node = controlled_node
	current_state.state_machine = self
	current_state.start()

## Cambiar de un estado a otro (Los estados son nodos hijos de StateMachine)
## Se ejecuta la función end() del estado actual antes de cambiar
func change_state(new_state_path: NodePath) -> void:
	if current_state and current_state.has_method('end'): 
		current_state.end()
	current_state = get_node(new_state_path)
	_start_state()

#region Sobreescribimos Callbacks de godot del nodo

# Se sobreescriben los callbacks de los estados para que solo se ejecute el estado actual
func _process(delta:float) -> void:
	if current_state and current_state.has_method("on_process"):
		current_state.on_process(delta)
		
func _physics_process(delta:float) -> void:
	if current_state and current_state.has_method("on_physics_process"):
		current_state.on_physics_process(delta)
		
func _input(event:InputEvent) -> void:
	if current_state and current_state.has_method("on_input"):
		current_state.on_input(event)
		
func _unhandled_input(event:InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_input"):
		current_state.on_unhandled_input(event)
		
func _unhandled_key_input(event:InputEvent) -> void:
	if current_state and current_state.has_method("on_unhandled_key_input"):
		current_state.on_unhandled_key_input(event)

#endregion
