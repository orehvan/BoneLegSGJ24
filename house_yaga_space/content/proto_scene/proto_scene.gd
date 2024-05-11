class_name GameplayScene
extends Node2D

@onready var _player_rocket_house: RocketHouse = %RocketHouse as RocketHouse
@onready var _rocket_spawn: Node2D = %RocketSpawn
@onready var _guide: Node2D = %Gude
@onready var _preview: CanvasLayer = %Preview
@onready var _animation_player_preview: AnimationPlayer = %AnimationPlayerPrivew
@onready var _portal: Node2D = $Portal
@onready var _boss_room: Node2D = $BossRoom

@export var zoom_from: float = 0.5
@export var zoom_to: float = 0.22

@export var engine_count: int = 5

var _is_start := false
var _camera_locked := true
var _camera_zoom_target: float = 0.5

var _last_portal_position := Vector2.ZERO

func _ready() -> void:
	_last_portal_position = _portal.position
	#_portal.player_entered.connect(_on_portal_player_entered)
	Global.progress_completed.connect(_on_progress_completed)

func start() -> void :
	MusicManager.play_our_game()
	_rocket_spawn.rocket_spawn = engine_count
	_rocket_spawn.start()
	Global.player_flying = false
	_camera_locked = true
	_guide.visible = false
	Global.enable_cursor = false
	Global.target_exit = null
	_portal.position = Vector2.DOWN * 100000
	

func _on_progress_completed() -> void :
	Global.target_exit = _portal
	Global.enable_cursor = true
	_portal.position = _last_portal_position

func _on_portal_player_entered() -> void :
	if Global.player :
		var point: Node2D = _boss_room.get_marker_spawn()
		_boss_room.start()
		var player := Global.player as RocketHouse
		player.warp_to = point.global_position
		player.health = player.max_health
		MusicManager.play_battle()

func show_guide() -> void :
	_guide.visible = true
	_preview.visible = true
	_animation_player_preview.play("play")

func _player_on_dead() -> void :
	get_tree().current_scene.get_ui().game_over_menu()

func _on_button_pressed() -> void:
	if _is_start :
		return
	
	var rocket_on_attach_list: Array[RocketPartEngine] = []
	
	var destroyed: Array[RocketPartEngine] = []
	for i in _rocket_spawn.get_child_count() :
		var node := _rocket_spawn.get_child(i) as RocketPartEngine
		if node :
			if node.is_on_player() :
				rocket_on_attach_list.append(node)
			else :
				destroyed.append(node)
	
	if rocket_on_attach_list.is_empty() :
		return
	
	for node in destroyed :
		node.destroy()
	
	_player_rocket_house.attack_rocket_engine_from_list(rocket_on_attach_list)
	_player_rocket_house.start_space_house()
	_is_start = true
	
	var camera := get_viewport().get_camera_2d()
	var tween := get_tree().create_tween()
	tween.tween_property(camera, "zoom", Vector2.ONE * 0.5, 3.0)
	tween.tween_callback(_unlock_camera)
	
	MusicManager.play_game()
	Global.player_flying = true
	_guide.visible = false
	get_tree().current_scene.get_ui().game_space_menu()
	
	#TODO
	#get_tree().create_timer(3.0).timeout.connect(_on_portal_player_entered)


func _on_dead_zone_body_entered(_body: Node2D) -> void:
	get_tree().current_scene.get_ui().game_over_menu()

func _unlock_camera() -> void :
	_camera_locked = false

func _physics_process(_delta: float) -> void:
	if _player_rocket_house and not _camera_locked:
		var f: float = 0.0
		var speed: float = _player_rocket_house.linear_velocity.length()
		f = clamp(max(0.0, speed / _player_rocket_house.max_linear), 0.0, 1.0)
		_camera_zoom_target = lerpf(zoom_from, zoom_to, f)
		get_viewport().get_camera_2d().zoom = lerp(
			get_viewport().get_camera_2d().zoom, 
			_camera_zoom_target * Vector2.ONE,
			0.1)


func _on_animation_player_privew_animation_finished(_anim_name: StringName) -> void:
	_preview.visible = false


func _on_texture_button_pressed() -> void:
	_preview.visible = false
