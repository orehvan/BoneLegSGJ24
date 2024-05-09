extends CharacterBody2D

@export var speed := 100.0
@export var damage := 10.0

func _physics_process(delta: float) -> void:
	var direction := Vector2.RIGHT.rotated(rotation).normalized()
	var motion := direction * speed * delta
	var collision := move_and_collide(motion)
	if collision :
		var object := collision.get_collider()
		if object is EnemyBase :
			object.apply_damage(damage)
		queue_free()


func _on_timer_life_time_timeout() -> void:
	queue_free()
