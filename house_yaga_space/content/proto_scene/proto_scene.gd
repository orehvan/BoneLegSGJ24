extends Node2D

@onready var _player_rocket_house: RocketHouse = %RocketHouse as RocketHouse
@onready var _rocket_spawn := %RocketSpawn

@export var zoom_from := 0.5
@export var zoom_to := 0.22

var _is_start := false
var _camera_locked := true
var _camera_zoom_target: float = 0.5

func _ready() -> void:
	MusicManager.play_our_game()

func _on_button_pressed() -> void:
	if _is_start :
		return
	
	var rocket_on_attach_list: Array[RocketPartEngine] = []
	
	for i in _rocket_spawn.get_child_count() :
		var node := _rocket_spawn.get_child(i) as RocketPartEngine
		if node :
			if node.is_on_player() :
				rocket_on_attach_list.append(node)
	
	if rocket_on_attach_list.is_empty() :
		return
	
	_player_rocket_house.attack_rocket_engine_from_list(rocket_on_attach_list)
	_player_rocket_house.start_space_house()
	_is_start = true
	
	var camera := get_viewport().get_camera_2d()
	var tween := get_tree().create_tween()
	tween.tween_property(camera, "zoom", Vector2.ONE * 0.5, 3.0)
	tween.tween_callback(_unlock_camera)
	
	MusicManager.play_game()
	Global.player_flying = true


func _on_dead_zone_body_entered(body: Node2D) -> void:
	Global.player_flying = false
	get_tree().reload_current_scene()

func _unlock_camera() -> void :
	_camera_locked = false

func _physics_process(delta: float) -> void:
	if _player_rocket_house and not _camera_locked:
		var f: float = 0.0
		var speed: float = _player_rocket_house.linear_velocity.length()
		f = max(0.0, speed / _player_rocket_house.max_linear)
		_camera_zoom_target = lerpf(zoom_from, zoom_to, f)
		get_viewport().get_camera_2d().zoom = lerp(
			get_viewport().get_camera_2d().zoom, 
			_camera_zoom_target * Vector2.ONE,
			0.1)
