extends Node

## Singleton that acts as an event bus for the game, allowing different parts of the game to communicate with each other directly through signals.

# ====================== PLAYER SIGNALS ======================

# ====================== CAMERA ZONE SIGNALS ======================
## Signal emitted when player enters a camera zone.
@warning_ignore("unused_signal")
signal player_entered_camera_zone(zone: CameraZone)

## Signal emitted when player exits a camera zone.
@warning_ignore("unused_signal")
signal player_exited_camera_zone(zone: CameraZone)


# ====================== CHECKPOINTS SIGNALS ======================

@warning_ignore("unused_signal")
signal checkpoint_activated( position_checkpoint :Vector2)

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
