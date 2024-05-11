extends Effect

@export var damage := 20


func _start() -> void :
	super._start()

func _finished() -> void :
	super._finished()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method(&"apply_damage") :
		body.apply_damage(damage)
