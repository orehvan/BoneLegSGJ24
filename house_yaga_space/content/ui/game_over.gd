extends Control


signal to_restart()
signal to_exit()


func _on_visibility_changed() -> void:
	if visible :
		Global.pause_count += 1
		MusicManager.pause()
	else :
		Global.pause_count -= 1
		MusicManager.resume()


func _on_button_restart_pressed() -> void:
	to_restart.emit()


func _on_button_exit_pressed() -> void:
	to_exit.emit()
