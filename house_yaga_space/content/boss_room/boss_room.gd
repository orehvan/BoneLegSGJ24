extends Node2D

@onready var _marker_spawn := $Marker2DSpawn
@onready var _boss := $Boss

func get_marker_spawn() -> Node2D :
	return _marker_spawn

func start() -> void :
	_boss.start()
