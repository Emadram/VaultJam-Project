extends Node

# AudioManager Singleton
# Handles playback of sound effects and music

var sfx_players: Array[AudioStreamPlayer] = []
var music_player: AudioStreamPlayer

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Create Music Player
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music"
	add_child(music_player)
	
	# Create SFX Pool (10 players)
	for i in range(10):
		var p = AudioStreamPlayer.new()
		p.bus = "SFX"
		add_child(p)
		sfx_players.append(p)

func play_sfx(stream: AudioStream, pitch_variance: float = 0.0) -> void:
	if not stream: return
	
	# Find available player
	var player = _get_available_player()
	if player:
		player.stream = stream
		player.pitch_scale = 1.0 + randf_range(-pitch_variance, pitch_variance)
		player.play()

func _get_available_player() -> AudioStreamPlayer:
	for p in sfx_players:
		if not p.playing:
			return p
	# If all busy, steal oldest? Or just return first.
	return sfx_players[0]

func play_music(stream: AudioStream) -> void:
	if music_player.stream == stream and music_player.playing:
		return
	music_player.stream = stream
	music_player.play()
