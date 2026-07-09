
extends Node

# ── Bancos de sonido ──────────────────────────────────────
@export var bank_player: SoundBank
@export var bank_enemies: SoundBank
@export var bank_world: SoundBank
@export var bank_ui: SoundBank
@export var bank_music: SoundBank
@export var bank_voces_intro: SoundBank


# ── Pool de SFX (8 players reutilizables) ─────────────────
const POOL_SIZE = 8
var _sfx_pool: Array[AudioStreamPlayer] = []

# ── Música ────────────────────────────────────────────────
var _music_player: AudioStreamPlayer
var _music_player_b: AudioStreamPlayer  # para crossfade

var _voice_player: AudioStreamPlayer

# ── Todos los bancos juntos para buscar por nombre ─────────
var _all_banks: Array[SoundBank] = []

# ──────────────────────────────────────────────────────────

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	_setup_sfx_pool()
	_setup_music_players()
	_voice_player = AudioStreamPlayer.new()
	_voice_player.bus = "Voices"
	add_child(_voice_player)
	
	_all_banks = [bank_player, bank_enemies, bank_world, bank_ui , bank_voces_intro]

func _setup_sfx_pool() -> void:
	for i in POOL_SIZE:
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		_sfx_pool.append(p)

func _setup_music_players() -> void:
	_music_player = AudioStreamPlayer.new()
	_music_player.bus = "Music"
	add_child(_music_player)
	
	_music_player_b = AudioStreamPlayer.new()
	_music_player_b.bus = "Music"
	add_child(_music_player_b)

# ── Reproducir SFX ────────────────────────────────────────

func play_sfx(sound_name: String, volume_db: float = 0.0, pitch: float = 1.0) -> void:
	var stream = _find_stream(sound_name)
	if stream == null:
		push_warning("SoundManager: sonido '%s' no encontrado" % sound_name)
		return
	
	var player = _get_free_player()
	if player == null:
		return
	
	player.stream = stream
	player.volume_db = volume_db
	# Variación aleatoria leve para que no suene repetitivo
	player.pitch_scale = pitch + randf_range(-0.05, 0.05)
	player.play()

func play_ui(sound_name: String) -> void:
	var stream = _find_stream_in_bank(bank_ui, sound_name)
	if stream == null:
		return
	var player = _get_free_player()
	if player == null:
		return
	player.bus = "UI"
	player.stream = stream
	player.pitch_scale = 1.0
	player.play()
	# Restaurar bus después de reproducir
	await player.finished
	player.bus = "SFX"

func play_voice(sound_name: String) -> void:
	var stream = _find_stream_in_bank(bank_voces_intro, sound_name)
	if stream == null:
		push_warning("SoundManager: voz '%s' no encontrada" % sound_name)
		return

	_voice_player.stream = stream
	_voice_player.volume_db = 0.0
	_voice_player.play()


func stop_voice() -> void:
	if _voice_player.playing:
		_voice_player.stop()

# ── Reproducir música ─────────────────────────────────────

func play_music(song_name: String, fade_time: float = 1.0) -> void:
	var stream = _find_stream_in_bank(bank_music, song_name)
	if stream == null:
		push_warning("SoundManager: música '%s' no encontrada" % song_name)
		return
	
	if _music_player.playing:
		# Crossfade: sube el B mientras baja el A
		_music_player_b.stream = stream
		_music_player_b.volume_db = -80.0
		_music_player_b.play()
		var tween = create_tween()
		tween.set_parallel(true)
		tween.tween_property(_music_player, "volume_db", -80.0, fade_time)
		tween.tween_property(_music_player_b, "volume_db", 0.0, fade_time)
		await tween.finished
		_music_player.stop()
		# Intercambia los players para el próximo crossfade
		var tmp = _music_player
		_music_player = _music_player_b
		_music_player_b = tmp
	else:
		_music_player.stream = stream
		_music_player.volume_db = 0.0
		_music_player.play()

func stop_music(fade_time: float = 1.0) -> void:
	var tween = create_tween()
	tween.tween_property(_music_player, "volume_db", -80.0, fade_time)
	await tween.finished
	_music_player.stop()

# ── Control de volumen por bus ────────────────────────────

func set_bus_volume(bus_name: String, volume_db: float) -> void:
	var idx = AudioServer.get_bus_index(bus_name)
	if idx != -1:
		AudioServer.set_bus_volume_db(idx, volume_db)

func get_bus_volume(bus_name: String) -> float:
	var idx = AudioServer.get_bus_index(bus_name)
	if idx != -1:
		return AudioServer.get_bus_volume_db(idx)
	return 0.0

# ── Funciones internas ────────────────────────────────────

func _find_stream(sound_name: String) -> AudioStream:
	for bank in _all_banks:
		if bank == null:
			continue
		var stream = _find_stream_in_bank(bank, sound_name)
		if stream != null:
			return stream
	return null

func _find_stream_in_bank(bank: SoundBank, sound_name: String) -> AudioStream:
	if bank == null or not bank.sounds.has(sound_name):
		return null
	var arr = bank.sounds[sound_name] as Array
	if arr == null or arr.is_empty():
		return null
	# Elige uno al azar si hay varios
	return arr[randi() % arr.size()] as AudioStream

func _get_free_player() -> AudioStreamPlayer:
	for player in _sfx_pool:
		if not player.playing:
			return player
	# Si todos están ocupados, interrumpe el que lleva más tiempo
	return _sfx_pool[0]
