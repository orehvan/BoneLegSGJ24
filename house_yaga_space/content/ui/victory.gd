extends Control

signal to_back()

@onready var _starting_rigid := $Start/RigidBody2D
@onready var _audio_victory := $AudioStreamPlayer

func _on_button_pressed() -> void:
	to_back.emit()


func _on_visibility_changed() -> void:
	if visible :
		if _starting_rigid :
			_starting_rigid.freeze = true
			await get_tree().physics_frame
			_starting_rigid.position = Vector2.ZERO
			await get_tree().physics_frame
			_starting_rigid.freeze = false
		if _audio_victory :
			_audio_victory.play()
	else :
		if _starting_rigid :
			_starting_rigid.freeze = true
		if _audio_victory :
			_audio_victory.stop()
	
