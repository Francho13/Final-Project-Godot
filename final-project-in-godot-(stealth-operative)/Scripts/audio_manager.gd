extends Node

var audio_player: AudioStreamPlayer

func _ready():
	audio_player = AudioStreamPlayer.new()
	add_child(audio_player)
	audio_player.stream = preload("res://Music and SFX/Main Menu.mp3")
	audio_player.bus = "Music"
	audio_player.play()


func stop_audio():
	if audio_player.is_playing():
		audio_player.stop()


func play_audio():
	if not audio_player.is_playing():
		audio_player.play()
