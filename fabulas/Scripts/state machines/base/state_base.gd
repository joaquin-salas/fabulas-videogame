class_name StateBase
extends Node

## Clase "abstracta" base con la estructura para estados FSM.

## Referencia al nodo que va a controlar la maquina de estados
var controlled_node: Node

## Referencia a la máquina de estados
var state_machine: StateMachine

#region Metodos comunes

## Se ejecuta al entrar en el estado
func start() -> void:
	pass

## Se ejecuta al salir del estado
func end() -> void:
	pass

## Se ejecutará en cada frame de físicas
func on_physics_process(delta: float) -> void:
	pass

## Manejo del input para cambiar de estado
func on_input(event) -> void:
	pass

#endregion
