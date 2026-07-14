class_name SoundBank
extends Resource

## A data container that holds a collection of related sounds.
##
## Used by the [SoundManager] to group and retrieve AudioStreams by name.

## Dictionary mapping sound names to their respective audio files.
## [br]
## - Key: [String] (The identifier for the sound, e.g., "jump", "hurt"). [br]
## - Value: [AudioStream] (Array of .wav, .ogg or .mp3 audio resource).
@export var sounds: Dictionary[String, Array] = {}

## Base volume offset (in decibels) applied to all sounds within this bank.
@export var base_volume_db: float = 0.0

# Quizá usar una clase interna para poder tipar el value del diccionary
# class AudioStreamGroup extends Resource:
# 	@export var streams: Array[AudioStream] = []