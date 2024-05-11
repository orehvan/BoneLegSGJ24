class_name UIScene
extends CanvasLayer

signal restart()
signal start_game()

@onready var _tab_container: TabContainer = %TabContainer

enum TypeMenu {
	MainMenu,
	Pause,
	Options,
	GameOver,
	GameStart,
	GameSpace,
	Victory,
	Story,
}

var _history_stack := []

@export var current_menu: TypeMenu = TypeMenu.MainMenu :
	set(val) :
		
		current_menu = val
		_tab_container.current_tab = int(current_menu)

func back() -> void :
	current_menu = _history_stack.pop_back()

func _write_history() -> void :
	_history_stack.push_back(current_menu)
	if _history_stack.size() > 10 :
		_history_stack.pop_front()

func main_menu() -> void :
	_write_history()
	current_menu = TypeMenu.MainMenu
	MusicManager.resume()
	MusicManager.play_our_game()

func pause_menu() -> void :
	_write_history()
	current_menu = TypeMenu.Pause

func option_menu() -> void :
	_write_history()
	current_menu = TypeMenu.Options

func game_over_menu() -> void :
	_write_history()
	current_menu = TypeMenu.GameOver

func game_start_menu() -> void :
	_write_history()
	MusicManager.resume()
	current_menu = TypeMenu.GameStart

func game_space_menu() -> void :
	_write_history()
	current_menu = TypeMenu.GameSpace
	

func story_menu() -> void:
	_write_history()
	current_menu = TypeMenu.Story

func victory_menu() -> void :
	_write_history()
	current_menu = TypeMenu.Victory
	MusicManager.pause()

func _on_main_menu_to_exit() -> void:
	get_tree().quit()


func _on_main_menu_to_options() -> void:
	option_menu()


func _on_main_menu_to_start() -> void:
	restart.emit()
	start_game.emit()
	Global.reset()
	game_start_menu()
	
func _on_main_menu_to_story() -> void:
	story_menu()


func _on_pause_to_back() -> void:
	back()


func _on_pause_to_exit() -> void:
	main_menu()


func _on_pause_to_option() -> void:
	option_menu()


func _on_game_over_to_exit() -> void:
	main_menu()


func _on_game_over_to_restart() -> void:
	restart.emit()
	start_game.emit()
	Global.reset()
	game_start_menu()


func _input(event: InputEvent) -> void:
	if event is InputEventKey :
		if event.keycode in [KEY_Q, KEY_ESCAPE] :
			if event.is_pressed() :
				if current_menu in [TypeMenu.GameStart, TypeMenu.GameSpace] :
					get_viewport().set_input_as_handled()
					pause_menu()
				elif current_menu in [TypeMenu.Pause, TypeMenu.Options] :
					get_viewport().set_input_as_handled()
					back()


func _on_options_to_back() -> void:
	back()


func _on_start_game_to_pause() -> void:
	pass # Replace with function body.


func _on_space_game_to_pause() -> void:
	pass # Replace with function body.
	
func _on_story_to_main_menu():
	back()


func _on_victory_to_back() -> void:
	MusicManager.resume()
	main_menu()
