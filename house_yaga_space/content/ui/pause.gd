extends Control

signal to_back()
signal to_option()
signal to_exit()




func _on_button_resume_pressed() -> void:
	to_back.emit()


func _on_button_options_pressed() -> void:
	to_option.emit()


func _on_button_exit_pressed() -> void:
	to_exit.emit()


func _on_visibility_changed() -> void:
	if visible :
		Global.pause_count += 1
		MusicManager.pause()
	else :
		Global.pause_count -= 1
		MusicManager.resume()


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") :
		if visible :
			to_back.emit()
