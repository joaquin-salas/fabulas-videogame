extends Node

## SignalBus is a singleton that acts as an event bus for the game, allowing different parts of the game to communicate with each other directly through signals.

# ====================== PLAYER SIGNALS ======================
## Signal emiited when player stablishes his max health. The max health value is passed as an argument.
@warning_ignore("unused_signal")
signal player_max_health_set(max_health: int)

## Signal emitted when player's health changes. The new health value is passed as an argument.
@warning_ignore("unused_signal")
signal player_health_changed(new_health: int)

## Signal emitted when player dies.
@warning_ignore("unused_signal")
signal player_died()
