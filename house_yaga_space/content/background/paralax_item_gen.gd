@tool
extends ParallaxLayer


@export var resource: Array[Resource] = [null]

@export var size := Vector2(2048, 2048)
@export var count_item: int = 100

@export var gen: bool = false :
	set(val) :
		gen = false
		if val :
			_gen()
			update_configuration_warnings()

func _gen() -> void :
	for i in get_child_count() :
		var node := get_child(i)
		node.queue_free()
	
	await get_tree().process_frame
	
	for i in count_item :
		var res: Resource = resource[randi_range(0, resource.size() - 1)]
		var node: Node2D = null
		if res is PackedScene :
			node = res.instantiate()
		elif res is Texture :
			var sprite = Sprite2D.new()
			sprite.texture = res
			node = sprite
		
		node.scale = Vector2.ONE * 4.0
		node.position = Vector2(
			randf_range(0.0, size.x),
			randf_range(0.0, size.y)
		)
		
		add_child(node, true)
		node.owner = owner if owner else self
