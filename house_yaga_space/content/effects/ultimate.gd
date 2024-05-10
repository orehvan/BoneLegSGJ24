extends Effect

@export var damage := 300.0

func _start() -> void :
	
	var parent: RocketHouse = get_parent() as RocketHouse
	if parent :
		parent.multi_speed *= 2.0
		parent.multi_max_linear *= 2.0
		parent.god_mode_count += 1
	super._start()

func _finished() -> void :
	var parent: RocketHouse = get_parent() as RocketHouse
	if parent :
		parent.multi_speed *= 0.5
		parent.multi_max_linear *= 0.5
		parent.god_mode_count -= 1
	super._finished()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is EnemyBase :
		body.apply_damage(damage)
	elif body is Planet :
		body.apply_damage(damage)
