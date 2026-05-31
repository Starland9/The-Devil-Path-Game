extends Node

# Placeholder audio via AudioStreamGenerator — no external assets needed.
# Call SFX.play("death") / SFX.play("win") etc. from anywhere.

var _player: AudioStreamPlayer

func _ready() -> void:
	_player = AudioStreamPlayer.new()
	add_child(_player)

func play(sfx_name: String) -> void:
	match sfx_name:
		"death":   _play_tone(180.0, 0.18, 0.25)
		"win":     _play_tone(880.0, 0.12, 0.45)
		"trap":    _play_tone(110.0, 0.20, 0.35)
		"collect": _play_tone(660.0, 0.10, 0.18)
		"jump":    _play_tone(440.0, 0.06, 0.09)
		"dash":    _play_tone(330.0, 0.07, 0.12)

func _play_tone(freq: float, volume: float, duration: float) -> void:
	var stream := AudioStreamGenerator.new()
	stream.mix_rate = 44100.0
	stream.buffer_length = duration
	_player.stream = stream
	_player.volume_db = linear_to_db(volume)
	_player.play()
	var playback := _player.get_stream_playback() as AudioStreamGeneratorPlayback
	if playback == null:
		return
	var samples := int(stream.mix_rate * duration)
	for i in samples:
		var t := float(i) / stream.mix_rate
		var envelope := 1.0 - (t / duration)
		var sample := sin(TAU * freq * t) * envelope
		playback.push_frame(Vector2(sample, sample))
