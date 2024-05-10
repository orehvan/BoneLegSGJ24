class_name Effect
extends Node2D

@export var time_life := 5.0


var _left_time := 0.0

func _ready() -> void:
	_start()

func _start() -> void :
	pass

func _finished() -> void :
	queue_free()
	pass

func _process(delta: float) -> void:
	if time_life <= 0.0 :
		return
	
	_left_time += delta
	if _left_time >= time_life :
		_finished()
