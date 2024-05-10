extends Node2D


@export var rocket_spawn: int = 5

const ENGINES: Array[PackedScene] = [
	preload("res://house_yaga_space/content/rocket_engine/rocket_engine_1.tscn"),
	preload("res://house_yaga_space/content/rocket_engine/rocket_engine_2.tscn"),
	preload("res://house_yaga_space/content/rocket_engine/rocket_engine_3.tscn"),
	preload("res://house_yaga_space/content/rocket_engine/rocket_engine_4.tscn"),
	preload("res://house_yaga_space/content/rocket_engine/rocket_engine_5.tscn"),
]

func start() -> void :
	_spawn()

func _spawn() -> void :
	var count := get_child_count()
	if count < rocket_spawn :
		var pkg := ENGINES[randi_range(0, ENGINES.size() - 1)]
		var engine: RocketPartEngine = pkg.instantiate() as RocketPartEngine
		if engine :
			add_child(engine)
			engine.drag.connect(_on_drag, CONNECT_ONE_SHOT)
			

func _on_drag() -> void :
	_spawn.call_deferred()
