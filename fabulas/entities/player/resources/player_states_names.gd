class_name PlayerStatesNames

## Class that holds all the state names for the player.

# No pueden ser StringName porque el método donde se utilizan esperan un NodePath
const IDLE := 'PlayerIdleState'
const RUNNING := 'PlayerRunState'
const JUMPING := 'PlayerJumpState'
const FALLING := 'PlayerFallState'
const HURT := 'PlayerHurtState'
const DEAD := 'PlayerDeadState'
const GODFLY:= 'PlayerGodFlyState'
