extends Node

@onready var _game_placeholder: InstancePlaceholder = %Game
@onready var _ui: UIScene = %Ui

var current_game: GameplayScene = null
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_game = _game_placeholder.create_instance()


func restart() -> void :
	if current_game :
		current_game.queue_free()
		current_game = null
	
	current_game = _game_placeholder.create_instance()


func get_current_game() -> Node :
	return current_game

func get_ui() -> UIScene :
	return _ui

func _on_ui_restart() -> void:
	restart()

func _on_ui_start_game() -> void:
	if current_game :
		current_game.start()
		current_game.show_guide()
