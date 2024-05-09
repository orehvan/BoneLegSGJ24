@tool
extends Node2D

@export var rescale := 1.0

@export var count_object: int = 1000
@export var y_max_pos: float = 10000.0
@export var x_max_pos: float = 10000.0
@export var packeds: Array[PackedScene] = []


@export var gen: bool = false :
	set(val) :
		gen = false
		if val :
			_gen()
		update_configuration_warnings()

func _gen() -> void :
	for n in get_child_count() :
		var node := get_child(n)
		node.queue_free()
	
	await get_tree().process_frame
	
	for i in count_object :
		var index_packed := randi_range(0, packeds.size() - 1)
		var packed := packeds[index_packed]
		var obj: Node2D = packed.instantiate() as Node2D
		var pos := Vector2(
			randf_range(-x_max_pos, x_max_pos),
			randf_range(0, -y_max_pos)
		)
		obj.scale = Vector2.ONE * rescale
		obj.position = pos
		add_child(obj, true)
		obj.owner = owner if owner else self
