class_name Boss
extends CharacterBody2D

@onready var _tentacles: Node2D = $Renderer/Tentacles
@export var speed := 2000
@export var contact_damage := 10.0
@export var laser_damage := 10.0
@export var health := 2000.0 :
	set(val) :
		health = val
		if health <= 0 :
			_death()

var _started := false

func _ready() -> void:
	pass

func start() -> void :
	_start_animation()

func _start_animation() -> void :
	for node in _tentacles.get_children() :
		if node is Node2D :
			var tween := get_tree().create_tween()
			tween.tween_property(node, "rotation_degrees", 20.0 + node.rotation_degrees, randf_range(0.5, 1.0))
			tween.tween_property(node, "rotation_degrees", -20.0 + node.rotation_degrees, randf_range(0.5, 1.0))
			tween.set_loops(1000)
	
	

func apply_damage(damage: float) -> void :
	health -= damage

func _physics_process(delta: float) -> void:
	if Global.player and _started :
		var direction := global_position.direction_to(Global.player.global_position)
		var vel := direction * speed * delta
		var collide := move_and_collide(vel)
		if collide :
			var collider := collide.get_collider()
			if collider is RocketHouse :
				collider.apply_damage(contact_damage)

func _death() -> void :
	queue_free()
