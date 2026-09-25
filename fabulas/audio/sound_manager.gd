extends Node

# ====================== LOCAL VARIABLES ======================
@export var bank_player: SoundBank
@export var bank_enemies: SoundBank
@export var bank_world: SoundBank
@export var bank_ui: SoundBank
@export var bank_music: SoundBank
@export var bank_voces_intro: SoundBank


# SFX Player
## Pool of AudioStreamPlayers to optimize performance by reusing nodes, 
## allowing up to [POOL_SIZE] sound effects to play simultaneously.
const POOL_SIZE = 8
var _sfx_pool: Array[AudioStreamPlayer] = []

# Music Player 
# _music_player_a es siempre la música "actual"; _music_player_b es la que sale/espera
var _music_player_a: AudioStreamPlayer
var _music_player_b: AudioStreamPlayer  # para crossfade
var _music_tween: Tween

# Voice Player
var _voice_player: AudioStreamPlayer

# All sound banks together to perform search operations
var _all_banks: Array[SoundBank] = []


# ******************* SETUP FUNCTIONS *******************
func _ready() -> void:
	# Sounds keep playing even when the node tree is paused
	self.process_mode = Node.PROCESS_MODE_ALWAYS

	# AudioStreamPlayers instantiation
	_setup_sfx_pool()
	_setup_music_players()
	_setup_voice_player()
	
	_all_banks = [bank_player, bank_enemies, bank_world, bank_ui , bank_voces_intro]

func _setup_sfx_pool() -> void:
	for i in POOL_SIZE:
		var sfx_player = AudioStreamPlayer.new()
		sfx_player.bus = AudioBuses.SFX
		add_child(sfx_player)
		_sfx_pool.append(sfx_player)

func _setup_music_players() -> void:
	_music_player_a = AudioStreamPlayer.new()
	_music_player_a.bus = AudioBuses.MUSIC
	add_child(_music_player_a)
	
	_music_player_b = AudioStreamPlayer.new()
	_music_player_b.bus = AudioBuses.MUSIC
	add_child(_music_player_b)

func _setup_voice_player() -> void:
	_voice_player = AudioStreamPlayer.new()
	_voice_player.bus = AudioBuses.VOICES
	add_child(_voice_player)

# ******************* AUDIO PLAY FUNCTIONS *******************
func play_sfx(sound_name: String, volume_db: float = 0.0, pitch: float = 1.0) -> void:
	var stream = _find_stream(sound_name)
	if stream == null:
		push_warning("SoundManager: sonido '%s' no encontrado" % sound_name)
		return
	
	var player = _get_free_player()
	if player == null:
		push_warning("SoundManager: no free players found.")
		return
	
	player.stream = stream
	player.volume_db = volume_db
	# Variación aleatoria leve para que no suene repetitivo
	player.pitch_scale = pitch + randf_range(-0.05, 0.05)
	player.play()

func play_footstep(surface: String = "default", volume_db: float = -6.0) -> void:
	var key := "step_" + surface
	# Si no existe esa superficie, cae al sonido por defecto
	if _find_stream(key) == null:
		key = "step_default"
	play_sfx(key, volume_db)

func play_ui(sound_name: String) -> void:
	var stream = _find_stream_in_bank(bank_ui, sound_name)
	if stream == null:
		push_warning("SoundManager: sonido '%s' no encontrado" % sound_name)
		return

	var player = _get_free_player()
	if player == null:
		push_warning("SoundManager: no free players found.")
		return
		
	# Los sonidos de la UI reutilizan el pool de players de SFX, 
	# por lo que se cambia el bus y se espera a que termine el sonido para volver al bus "SFX"
	# Esto está bien para optimizar recursos pero puede ser contraintuitivo, quizá se podría refactorizar 
	# para que el bus "UI" utilice sus propios AudioStreamPlayers?
	player.bus = AudioBuses.UI
	player.stream = stream
	player.pitch_scale = 1.0
	player.play()
	await player.finished
	player.bus = AudioBuses.SFX


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


func play_music(song_name: String, fade_time: float = 1.0) -> void:
	var stream = _find_stream_in_bank(bank_music, song_name)
	if stream == null:
		push_warning("SoundManager: música '%s' no encontrada" % song_name)
		return

	# Cancela cualquier fade pendiente (p. ej. el de un stop_music anterior),
	# para que ningún stop() tardío pise la música nueva.
	if _music_tween:
		_music_tween.kill()
	# Si quedaba un crossfade a medias, corta la que estaba saliendo.
	_music_player_b.stop()

	# Intercambio inmediato: _music_player_a siempre es la música "actual"
	var outgoing := _music_player_a
	var incoming := _music_player_b
	_music_player_a = incoming
	_music_player_b = outgoing

	var crossfade := outgoing.playing
	incoming.stream = stream
	incoming.volume_db = -80.0 if crossfade else 0.0
	incoming.play()

	if crossfade:
		_music_tween = create_tween().set_parallel(true)
		_music_tween.tween_property(outgoing, "volume_db", -80.0, fade_time)
		_music_tween.tween_property(incoming, "volume_db", 0.0, fade_time)
		_music_tween.chain().tween_callback(outgoing.stop)

func stop_music(fade_time: float = 1.0) -> void:
	if _music_tween:
		_music_tween.kill()
	# Si había un crossfade en curso, la que salía se corta ya.
	_music_player_b.stop()

	# Referencia local: aunque se llame a play_music durante el fade, 
	# este stop() solo afecta al player que estaba sonando al llamar.
	var player := _music_player_a
	_music_tween = create_tween()
	_music_tween.tween_property(player, "volume_db", -80.0, fade_time)
	_music_tween.tween_callback(player.stop)


# ******************* VOLUME FUNCTIONS *******************
func set_bus_volume(bus_name: String, volume_db: float) -> void:
	var idx = AudioServer.get_bus_index(bus_name)
	if idx != -1:
		AudioServer.set_bus_volume_db(idx, volume_db)

func get_bus_volume(bus_name: String) -> float:
	var idx = AudioServer.get_bus_index(bus_name)
	if idx != -1:
		return AudioServer.get_bus_volume_db(idx)
	return 0.0


# ******************* PRIVATE FUNCTIONS *******************
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
	return arr.pick_random() as AudioStream

func _get_free_player() -> AudioStreamPlayer:
	for player in _sfx_pool:
		if not player.playing:
			return player
	
	# Si todos están ocupados, interrumpe el que lleva más tiempo
	return _sfx_pool[0]
