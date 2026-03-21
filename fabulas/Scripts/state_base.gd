class_name StateBase
extends Node

## Clase padre con la estructura que tendrán los estados

# Referencia al nodo que va a controlar la maquina de estados
@onready var controlled_node: Node = self.owner

# Referencia a la máquina de estados
var state_machine: StateMachine

#region Metodos comunes

## Se ejecuta al entrar en el estado
func start() -> void:
	pass

## Se ejecuta al salir del estado
func end() -> void:
	pass

#endregion
