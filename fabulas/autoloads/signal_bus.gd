extends Node

## Singleton that acts as an event bus for the game, allowing different parts of the game to communicate with each other directly through signals.

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

# ====================== CAMERA ZONE SIGNALS ======================
## Signal emitted when player enters a camera zone.
@warning_ignore("unused_signal")
signal player_entered_camera_zone(zone: CameraZone)

## Signal emitted when player exits a camera zone.
@warning_ignore("unused_signal")
signal player_exited_camera_zone(zone: CameraZone)

# ====================== KEY SIGNALS ======================
@warning_ignore("unused_signal")
signal blue_key_take

@warning_ignore("unused_signal")
signal white_key_take

@warning_ignore("unused_signal")
signal purple_key_take

@warning_ignore("unused_signal")
signal hud_on
@warning_ignore("unused_signal")
signal hud_off

# ====================== LEVER SIGNALS ======================
@warning_ignore("unused_signal")
signal lever_toggled(lever_id: int, is_on: bool)
