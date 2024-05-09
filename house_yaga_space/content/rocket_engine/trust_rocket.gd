class_name TrustEngine
extends Node2D

const ANIM_RUN := "run"
const ANIM_STOP := "stop"

@onready var _marker_begin: Marker2D = %Marker2DBeginPoint
@onready var _marker_end: Marker2D = %Marker2DEndPoint
@onready var _animation_effect: AnimationPlayer = %AnimationPlayerEffects

var _is_started := false

func start() -> void :
	if _is_started :
		return
	_is_started = true
	_animation_effect.play(ANIM_RUN)

func stop() -> void :
	if not _is_started :
		return
	_is_started = false
	_animation_effect.play(ANIM_STOP)

func get_point_force_global() -> Vector2 :
	return _marker_end.global_position

func get_force_vector_direction_global() -> Vector2 :
	return _marker_end.global_position.direction_to(_marker_begin.global_position)
