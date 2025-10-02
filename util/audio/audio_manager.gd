extends Node

var num_players = 8
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.

var music_player: AudioStreamPlayer  # Dedicated for background music


func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var player = AudioStreamPlayer.new()
		add_child(player)
		available.append(player)
		player.finished.connect(_on_stream_finished.bind(player))
		player.bus = bus
		
	# Create dedicated music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = bus
	music_player.autoplay = false
	add_child(music_player)
		
func _on_stream_finished(stream):
	available.append(stream)
	
### --- SFX --- ###
func play(
		sound_path: String, 
		pitch: float = 1.0, 
		volume_db: float = 0.0,  
		bus: String = "master"
	):
	queue.append({ 
		"path": sound_path,
		"pitch": pitch,
		"volume": volume_db,
		"bus": bus
	})
	
func _process(_delta):
	if not queue.is_empty() and not available.is_empty():
		var sound_data = queue.pop_front()
		var player = available.pop_front()
		
		# Load and assign stream
		player.stream = load(sound_data.path)
		if player.stream == null:
			push_warning("AudioManager: Could not load sound " + str(sound_data.path))
			return
		
		# Apply properties
		player.pitch_scale = sound_data.pitch
		player.volume_db = sound_data.volume
		player.bus = sound_data.bus
		
		player.play()
		
		for p in get_children():
			if p is AudioStreamPlayer and not p.playing and not available.has(p) and p != music_player:
				available.append(p)
		
### --- MUSIC --- ###
func play_music(sound_path: String, loop: bool = true, volume_db: float = 0.0):
	var stream: AudioStream = load(sound_path)
	if stream == null:
		push_warning("AudioManager: Could not load music " + str(sound_path))
		return
	
	music_player.stop()
	music_player.stream = stream
	music_player.volume_db = volume_db
	
	# Enable looping if the stream type supports it
	if stream is AudioStreamMP3 or stream is AudioStreamOggVorbis or stream is AudioStreamWAV:
		stream.loop = loop
	
	music_player.play()

func stop_music():
	music_player.stop()

func is_music_playing() -> bool:
	return music_player.playing
