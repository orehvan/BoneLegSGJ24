class_name RocketHouse
extends RigidBody2D

signal dead()
signal change_health()

const INPUT_ENGINE_ACTIVE := "engine_active"

@onready var _rockets: Node2D = %Rockets
@onready var _left_trusters: Node2D = %LeftTruster
@onready var _right_truster: Node2D = %RightTruster
@onready var _cursor: Node2D = %Cursor

@onready var _audio_hit: AudioStreamPlayer2D = $AudioStreamPlayer2DHit
@onready var _audio_death: AudioStreamPlayer2D = $AudioStreamPlayer2DDeath
@onready var _audio_heal: AudioStreamPlayer2D = $AudioStreamPlayer2DHeal

var _started: bool = false
var _engine_active: bool = false

var _line_drawing: Array = []

@export var rotation_force := 100.0
@export var distance_rot := 100.0
@export var max_linear := 800.0
@export var multi_speed := 1.0
@export var multi_max_linear := 1.0
@export var god_mode_count := 0 :
	set(val) :
		god_mode_count = maxi(0, val)
@export var max_health := 1000.0
@export var health := 1000.0 :
	set(val) :
		if god_mode_count and val < health :
			return
		if val > health :
			if _audio_heal :
				_audio_heal.play()
		
		health = clampf(val, 0.0, max_health)
		change_health.emit()
		
		if health <= 0 :
			_death()

var warp_to := Vector2.INF

func _ready() -> void:
	health = max_health
	Global.player = self 
	dead.connect(get_parent()._player_on_dead)

func _attach_rocket_engine(rocket_engine: RocketPartEngine) -> void :
	if rocket_engine :
		if rocket_engine.is_on_player() :
			var local_pos := to_local(rocket_engine.global_position)
			rocket_engine.disable_attach()
			rocket_engine.get_parent().remove_child(rocket_engine)
			rocket_engine.position = local_pos
			_rockets.add_child(rocket_engine)

func attack_rocket_engine_from_list(list: Array[RocketPartEngine]) -> void :
	for rocket in list :
		_attach_rocket_engine(rocket)
	
	if Global.is_debug :
		_line_drawing.resize(list.size())
		_line_drawing.fill([Vector2.ZERO, Vector2.ZERO])



func start_space_house() -> void :
	freeze = false
	lock_rotation = false
	_started = true

func reset_space_house() -> void :
	freeze = true
	lock_rotation = true



func _death() -> void :
	dead.emit()
	_audio_death.play()

func apply_damage(damage: float) -> void :
	health -= damage
	_audio_hit.play()

func _draw() -> void:
	if Global.is_debug :
		for pair: Array in _line_drawing :
			var from: Vector2 = to_local(pair[0])
			var to: Vector2 = to_local(pair[1])
			draw_line(from, to, Color.RED, 5.0)
			draw_circle(to, 5.0, Color.CHARTREUSE)
			

func _physics_process(_delta: float) -> void:
	if not _started :
		return
	
	
	var pressed: bool = Input.is_action_pressed(INPUT_ENGINE_ACTIVE)
	_engine_active = pressed
	
	for i in _rockets.get_child_count() :
		var node := _rockets.get_child(i) as RocketPartEngine
		if node :
			if _engine_active :
				var global_point_force: Vector2 = node.get_point_force_global()
				var offset_global_force: Vector2 = global_position - global_point_force
				var force_vector: Vector2 = node.get_force_vector()
				apply_force(force_vector, offset_global_force)
				node.start()
				if Global.is_debug :
					_line_drawing[i][0] = global_point_force
					_line_drawing[i][1] = global_point_force + (node.get_force_vector_direction_global() * 100.0)
					queue_redraw()
			else :
				node.stop()
	
	var mouse_pos := get_global_mouse_position()
	var local_mouse_pos := to_local(mouse_pos)
	var x_offset_mouse := local_mouse_pos.x
	
	var truster_active := []
	var truster_disable := []
	if x_offset_mouse < 0.0 :
		truster_active = _left_trusters.get_children()
		truster_disable = _right_truster.get_children()
	elif x_offset_mouse > 0.0 :
		truster_active = _right_truster.get_children()
		truster_disable = _left_trusters.get_children()
	
	
	var force: float = clamp((absf(x_offset_mouse) / distance_rot), 0.0, 1.0)
	for node in truster_active :
		var trust := node as TrustEngine
		if trust :
			var global_point_force: Vector2 = trust.get_point_force_global()
			var offset_global_force: Vector2 = global_position - global_point_force
			var force_vector: Vector2 = trust.get_force_vector_direction_global() * rotation_force * force * multi_speed
			trust.start()
			apply_force(force_vector, offset_global_force)
	
	for node in truster_disable :
		var trust := node as TrustEngine
		if trust :
			trust.stop()
	
	linear_velocity = linear_velocity.normalized() * clamp(linear_velocity.length(), 0, max_linear * multi_max_linear)
	_cursor.visible = Global.enable_cursor
	if _cursor.visible and Global.target_exit:
		_cursor.look_at(Global.target_exit.global_position)
	
	if warp_to != Vector2.INF :
		global_position = warp_to
		warp_to = Vector2.INF

