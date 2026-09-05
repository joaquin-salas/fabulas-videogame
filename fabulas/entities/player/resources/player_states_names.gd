class_name PlayerStatesNames

## Class that holds all the state names for the player.

# It can't be a StringName data type because the method that uses this wants a NodePath.
const IDLE := 'PlayerIdleState'
const RUNNING := 'PlayerRunState'
const JUMPING := 'PlayerJumpState'
const FALLING := 'PlayerFallState'
const KNOCKBACK := 'PlayerKnockbackState'
const GODFLY:= 'PlayerGodFlyState'
