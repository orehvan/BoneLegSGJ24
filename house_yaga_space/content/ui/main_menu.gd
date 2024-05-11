extends Control

signal to_options()
signal to_start()
signal to_exit()
signal to_story()

@onready var _audio_click: AudioStreamPlayer = %AudioStreamPlayerClick
@onready var _exit := $VBoxContainer/HBoxContainer2/ButtonExit

func _ready() -> void:
	if OS.get_name() == "Web" :
		_exit.visible = false

func _on_button_exit_pressed() -> void:
	to_exit.emit()
	_audio_click.play()


func _on_button_options_pressed() -> void:
	to_options.emit()
	_audio_click.play()


func _on_button_start_pressed() -> void:
	to_start.emit()
	_audio_click.play()


func _on_button_story_pressed():
	to_story.emit()
	_audio_click.play()


func _on_visibility_changed() -> void:
	if visible :
		Global.pause_count += 1
	else :
		Global.pause_count -= 1


