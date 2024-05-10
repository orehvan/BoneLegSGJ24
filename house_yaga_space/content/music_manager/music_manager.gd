extends Node

const DURATION := 4.0
const SILENT := -80.0

@onready var _audio_our: AudioStreamPlayer = $AudioStreamPlayerOur
@onready var _audio_music_1: AudioStreamPlayer = $AudioStreamPlayerMusic1
@onready var _audio_music_2: AudioStreamPlayer = $AudioStreamPlayerMusic2
@onready var _audio_music_battle: AudioStreamPlayer = $AudioStreamPlayerMusicBattle


var _current_play: AudioStreamPlayer = null

func _ready() -> void:
	play_our_game()

func play_our_game() -> void :
	play_from(_audio_our)

func play_game() -> void :
	if _current_play == _audio_music_1 :
		play_from(_audio_music_2)
	elif _current_play == _audio_music_2 :
		play_from(_audio_music_battle)
	elif _current_play == _audio_music_battle :
		play_from(_audio_music_1)
	else :
		play_from(
			_audio_music_1 
			if randf() > 0.5 else _audio_music_2
			if randf() > 0.5 else _audio_music_battle)

func play_battle() -> void :
	play_from(_audio_music_battle)

func play_from(audio: AudioStreamPlayer) -> void :
	if audio == _current_play :
		return
	
	for audio_other: AudioStreamPlayer in get_children() :
		if audio != audio_other:
			audio_other.stop()
			#var tween_cilent := get_tree().create_tween()
			#tween_cilent.tween_property(audio_other, "volume_db", SILENT, DURATION)
			#tween_cilent.tween_callback(audio_other.stop)
	
	_current_play = audio
	_current_play.volume_db = 0.0
	_current_play.play()
	var tween := get_tree().create_tween()
	tween.tween_property(_current_play, "volume_db", 0.0, DURATION)

func pause() -> void :
	if _current_play :
		_current_play.stream_paused = true

func resume() -> void :
	if _current_play :
		_current_play.stream_paused = false

func _on_audio_stream_player_music_1_finished() -> void:
	play_game()


func _on_audio_stream_player_music_2_finished() -> void:
	play_game()



func _on_audio_stream_player_music_battle_finished() -> void:
	play_game()
