extends Control

signal to_back()

@onready var _audio_victory := $AudioStreamPlayer

func _on_button_pressed() -> void:
	to_back.emit()


func _on_visibility_changed() -> void:
	if visible :
		Global.pause_count += 1
		if _audio_victory :
			_audio_victory.play()
	else :
		if _audio_victory :
			_audio_victory.stop()
	
