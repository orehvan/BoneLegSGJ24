extends Area2D


@export var packed_bonus: PackedScene = null


func _on_body_entered(body: Node2D) -> void:
	_add_effect_from_body.call_deferred(body)

func _add_effect_from_body(body: Node2D) -> void :
	var effect := packed_bonus.instantiate()
	body.add_child(effect)
	queue_free()
