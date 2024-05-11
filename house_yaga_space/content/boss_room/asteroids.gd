@tool
extends Node2D

@export var gen := false :
	set(val) :
		gen = false
		if val :
			_gen()
		update_configuration_warnings()

func _gen() -> void :
	for i in get_child_count() :
		var node: Node2D = get_child(i) as Node2D
		if node :
			var index_rot := randi_range(0, 3)
			node.rotation_degrees = index_rot * 90.0
