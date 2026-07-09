extends Control
class_name SettingsMenu

signal closed

const SETTINGS_PATH = "user://settings.cfg"

var pending_master: float = 100.0
var pending_sfx: float = 100.0
var pending_music: float = 100.0
var pending_voices: float = 100.0
var pending_mute: bool = false
var pending_resolution: int = 2
var pending_display: int = 0
var pending_vsync: int = 0
var pending_fps: int = 1
var pending_brightness: float = 1.0

# Respaldo para revertir si se pulsa Back sin Apply 
var _saved_master: float = 100.0
var _saved_sfx: float = 100.0
var _saved_music: float = 100.0
var _saved_voices: float = 100.0
var _saved_mute: bool = false
var _saved_resolution: int = 2
var _saved_display: int = 0
var _saved_vsync: int = 0
var _saved_fps: int = 1
var _saved_brightness: float = 1.0

# READY

func _ready() -> void:
	load_settings()
	apply_settings()
	update_ui()
	_snapshot_saved()

#  AL ABRIR EL MENÚ guarda el estado actual 

func _on_visibility_changed() -> void:
	if visible and is_inside_tree():
		_snapshot_saved()

func _snapshot_saved() -> void:
	_saved_master     = pending_master
	_saved_sfx        = pending_sfx
	_saved_music      = pending_music
	_saved_mute       = pending_mute
	_saved_voices     = pending_voices
	_saved_resolution = pending_resolution
	_saved_display    = pending_display
	_saved_vsync      = pending_vsync
	_saved_fps        = pending_fps
	_saved_brightness = pending_brightness

#  SEÑALES  aplican EN TIEMPO REAL 

func _safe_volume(value: float) -> float:
	return linear_to_db(max(value, 0.0001) / 100.0)

func _on_master_value_changed(value: float) -> void:
	pending_master = value
	SoundManager.set_bus_volume("Master", _safe_volume(value))

func _on_music_value_changed(value: float) -> void:
	pending_music = value
	SoundManager.set_bus_volume("Music", _safe_volume(value))

func _on_sfx_value_changed(value: float) -> void:
	pending_sfx = value
	SoundManager.set_bus_volume("SFX", _safe_volume(value))

func _on_voices_value_changed(value: float) -> void:
	pending_voices = value
	SoundManager.set_bus_volume("Voices", _safe_volume(value))
	
func _on_check_box_toggled(toggled_on: bool) -> void:
	pending_mute = toggled_on
	AudioServer.set_bus_mute(0, pending_mute)

func _apply_windowed_resolution() -> void:
	match pending_resolution:
		0: DisplayServer.window_set_size(Vector2i(1920, 1080))
		1: DisplayServer.window_set_size(Vector2i(1600, 900))
		2: DisplayServer.window_set_size(Vector2i(1280, 720))

func _on_resolution_item_selected(index: int) -> void:
	pending_resolution = index
	if pending_display == 0:
		_apply_windowed_resolution()

func _on_display_item_selected(index: int) -> void:
	pending_display = index
	match pending_display:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			_apply_windowed_resolution()
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

func _on_v_sync_item_selected(index: int) -> void:
	pending_vsync = index
	match pending_vsync:
		0: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

func _on_fps_item_selected(index: int) -> void:
	pending_fps = index
	match pending_fps:
		0: Engine.max_fps = 30
		1: Engine.max_fps = 60
		2: Engine.max_fps = 120
		3: Engine.max_fps = 0

func _on_brillo_value_changed(value: float) -> void:
	pending_brightness = value
	BrightnessManager.set_brightness(value)

# APPLY — confirma y guarda en disco

func _on_apply_pressed() -> void:
	save_settings()
	_snapshot_saved()

# BACK — revierte si no se aplicó 

func _on_back_pressed() -> void:
	pending_master     = _saved_master
	pending_music      = _saved_music
	pending_sfx        = _saved_sfx
	pending_mute       = _saved_mute
	pending_voices       = _saved_voices
	pending_resolution = _saved_resolution
	pending_display    = _saved_display
	pending_vsync      = _saved_vsync
	pending_fps        = _saved_fps
	pending_brightness = _saved_brightness

	apply_settings()
	update_ui()
	closed.emit()
	self.visible = false
	
# APPLY SETTINGS 

func apply_settings() -> void:
	SoundManager.set_bus_volume("Master", _safe_volume(pending_master))
	SoundManager.set_bus_volume("Music",  _safe_volume(pending_music))
	SoundManager.set_bus_volume("SFX",    _safe_volume(pending_sfx))
	SoundManager.set_bus_volume("Voices", _safe_volume(pending_voices))
	AudioServer.set_bus_mute(0, pending_mute)

	match pending_display:
		0:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
			_apply_windowed_resolution() 
		1:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, false)
		2:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)

	match pending_vsync:
		0: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)

	match pending_fps:
		0: Engine.max_fps = 30
		1: Engine.max_fps = 60
		2: Engine.max_fps = 120
		3: Engine.max_fps = 0

	BrightnessManager.set_brightness(pending_brightness) 

# GUARDAR / CARGAR

func save_settings() -> void:
	var config = ConfigFile.new()
	config.set_value("audio", "master",     pending_master)
	config.set_value("audio", "sfx",        pending_sfx)
	config.set_value("audio", "music",      pending_music)
	config.set_value("audio", "voices",      pending_voices)
	config.set_value("audio", "mute",       pending_mute)
	config.set_value("video", "resolution", pending_resolution)
	config.set_value("video", "display",    pending_display)
	config.set_value("video", "vsync",      pending_vsync)
	config.set_value("video", "fps",        pending_fps)
	config.set_value("video", "brightness", pending_brightness)
	config.save(SETTINGS_PATH)

func load_settings() -> void:
	var config = ConfigFile.new()
	if config.load(SETTINGS_PATH) != OK:
		return
	pending_master     = config.get_value("audio", "master",     100.0)
	pending_sfx        = config.get_value("audio", "sfx",        100.0)
	pending_music      = config.get_value("audio", "music",      100.0)
	pending_voices      = config.get_value("audio", "voices",      100.0)
	pending_mute       = config.get_value("audio", "mute",       false)
	pending_resolution = config.get_value("video", "resolution", 2)
	pending_display    = config.get_value("video", "display",    0)
	pending_vsync      = config.get_value("video", "vsync",      0)
	pending_fps        = config.get_value("video", "fps",        1)
	pending_brightness = config.get_value("video", "brightness", 1.0)


# UPDATE UI 

func update_ui() -> void:
	$TabContainer/Audio/audioContainer/Master/Master.value = pending_master
	$TabContainer/Audio/audioContainer/Sfx/Sfx.value = pending_sfx
	$TabContainer/Audio/audioContainer/Music/Music.value = pending_music
	$TabContainer/Audio/audioContainer/Voices/Voices.value = pending_voices
	$TabContainer/Audio/audioContainer/mute/CheckBox.button_pressed = pending_mute
	$TabContainer/Video/HBoxContainer/videoContainer2/resultion/Resolution.selected = pending_resolution
	$TabContainer/Video/HBoxContainer/videoContainer2/Display/Display.selected = pending_display
	$TabContainer/Video/HBoxContainer/videoContainer/VSync/VSync.selected = pending_vsync
	$TabContainer/Video/HBoxContainer/videoContainer/Fps/FPS.selected = pending_fps
	$TabContainer/Video/HBoxContainer/videoContainer2/brillo/Brillo.value = pending_brightness
