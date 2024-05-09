class_name RocketPartEngine
extends Node2D

const ANIM_RUN := "run"
const ANIM_STOP := "stop"

@onready var _marker_end_point: Marker2D = %Marker2DEndPoint
@onready var _marker_start_point: Marker2D = %Marker2DStartPoint
@onready var _animation_player: AnimationPlayer = %AnimationPlayerEffect
@onready var _area_2d_attach: Area2D = %Area2DAttach

@export_range(0.0, 1000000.0) var force: float = 100.0
@export var rotation_factor_input: float = 0.2

var _started := false
var _on_player := false

var _is_drag := false
var _attach_disabled := false

func get_point_force_global() -> Vector2 :
	return _marker_end_point.global_position

func get_force_vector_direction_global() -> Vector2 :
	return _marker_end_point.global_position.direction_to(_marker_start_point.global_position)

func get_force_vector() -> Vector2 :
	if not _started :
		return Vector2.ZERO
	return get_force_vector_direction_global() * force

func start() -> void :
	if not _started :
		_started = true
		_animation_player.play(ANIM_RUN)

func stop() -> void :
	if _started :
		_started = false
		_animation_player.play(ANIM_STOP)



func is_on_player() -> bool :
	return _on_player

func disable_attach() -> void :
	_area_2d_attach.monitoring = false
	_area_2d_attach.input_pickable = false
	modulate = Color.WHITE
	_attach_disabled = true

func enable_attach() -> void :
	_area_2d_attach.monitoring = true
	_area_2d_attach.input_pickable = true
	_attach_disabled = false

func _on_area_2d_attach_mouse_entered() -> void:
	modulate = Color.FOREST_GREEN

func _on_area_2d_attach_mouse_exited() -> void:
	modulate = Color.WHITE


func _on_area_2d_attach_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if _attach_disabled :
		return
	
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT :
			if event.is_released() :
				if not _is_drag :
					_is_drag = true
					get_viewport().set_input_as_handled()


func _unhandled_input(event: InputEvent) -> void:
	if _attach_disabled :
		return
	
	if event is InputEventMouseButton :
		if event.button_index == MOUSE_BUTTON_LEFT :
			if event.is_released() :
				if _is_drag :
					_is_drag = false
					get_viewport().set_input_as_handled()
		
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP :
			if _is_drag :
				rotation += rotation_factor_input
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN :
			if _is_drag :
				rotation -= rotation_factor_input
	

func _process(delta: float) -> void:
	if not _is_drag :
		return
	
	var mouse_pos := get_global_mouse_position()
	global_position = mouse_pos


func _on_area_2d_attach_area_entered(area: Area2D) -> void:
	_on_player = true


func _on_area_2d_attach_area_exited(area: Area2D) -> void:
	_on_player = false
