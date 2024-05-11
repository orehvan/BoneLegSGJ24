extends Control

signal to_options()
signal to_start()
signal to_exit()
signal to_story()


func _on_button_exit_pressed() -> void:
	to_exit.emit()


func _on_button_options_pressed() -> void:
	to_options.emit()


func _on_button_start_pressed() -> void:
	to_start.emit()


func _on_button_story_pressed():
	to_story.emit()


func _on_visibility_changed() -> void:
	if visible :
		Global.pause_count += 1
	else :
		Global.pause_count -= 1
