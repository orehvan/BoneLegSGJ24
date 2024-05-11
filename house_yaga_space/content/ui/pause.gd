extends Control

signal to_back()
signal to_option()
signal to_exit()


@onready var _god_mode: CheckBox = %CheckBoxGod


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
			var player := Global.player as RocketHouse
			if player :
				_god_mode.set_pressed_no_signal(player.god_mode_count > 0)
				


func _on_button_pressed() -> void:
	var scene := get_tree().current_scene
	if scene :
		var gameplaye_scene := scene.get_current_game() as GameplayScene
		var ui := scene.get_ui() as UIScene
		if gameplaye_scene and ui:
			if Global.player_flying :
				gameplaye_scene._on_portal_player_entered()


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on :
		var player := Global.player as RocketHouse
		if player :
			player.god_mode_count += 1
		else :
			player.god_mode_count -= 1
