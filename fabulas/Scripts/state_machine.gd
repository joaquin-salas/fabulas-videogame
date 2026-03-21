class_name StateMachine
extends Node

## Clase encargada de manejar los estados (prepara los estados y cambia entre ellos)

# Nodo que se va a controlar
@onready var controlled_node: Node = self.owner

# Estado por defecto al iniciar
@export var default_state: StateBase

# Estado activo en cada momento
var current_state: StateBase = null

func _ready() -> void:
	# Se llama a la función cuando todos los nodos han entrado en el SceneTree
	call_deferred("_start_default_state")
	
func _start_default_state() -> void:
	current_state = default_state
	_start_state()

## Prepara variables internas del estado activo y lanza su start
func _start_state() -> void:
	print('StateMachine ' + controlled_node.name + ' state start ' + current_state.name)
	
	# Configuramos el estado
	current_state.controlled_node = controlled_node
	current_state.state_machine = self
	current_state.start()

## Cambiar de un estado a otro (Los estados son nodos hijos de StateMachine)
func change_state(new_state_path: NodePath) -> void:
	if current_state and current_state.has_method('end'): 
		current_state.end()
	current_state = get_node(new_state_path)
	_start_state()

#region Callbacks



#endregion
