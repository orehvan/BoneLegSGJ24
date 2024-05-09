extends Node2D


@onready var _area_2d: Area2D = %Area2D
@onready var _header_helper: Node2D = %HeaderHelper

@export var starting_turret: PackedScene = null


var _current_turret: HeadTurret = null
var _count_enemy_detected := 0

func _ready() -> void:
	if starting_turret :
		_current_turret = starting_turret.instantiate() as HeadTurret
		add_child(_current_turret)
	
	_check_active()

func change_turret(packed: PackedScene) -> void :
	if _current_turret :
		_current_turret.queue_free()
		_current_turret = null
	
	_current_turret = packed.instantiate() as HeadTurret
	add_child(_current_turret)

func _check_active() -> void :
	if _count_enemy_detected > 0 :
		if _current_turret :
			_current_turret.start_shoot()
	else :
		if _current_turret :
			_current_turret.stop_shoot()
		
		_header_helper.look_at(_header_helper.global_position + Vector2.UP * 100.0)

func _on_area_2d_body_entered(body: Node2D) -> void:
	_count_enemy_detected += 1
	_check_active()


func _on_area_2d_body_exited(body: Node2D) -> void:
	_count_enemy_detected -= 1
	_check_active()

func _physics_process(delta: float) -> void:
	if _count_enemy_detected > 0 and _current_turret :
		var enemyes_list := _area_2d.get_overlapping_bodies()
		var short_enemy: Node2D = null
		var last_distance := 100000000
		for enemy in enemyes_list :
			if enemy is Node2D :
				var dist := global_position.distance_to(enemy.global_position)
				if dist < last_distance :
					short_enemy = enemy
					last_distance = dist
		
		if short_enemy :
			_header_helper.look_at(short_enemy.global_position)
		
	if _current_turret :
		_current_turret.rotation = lerp_angle(_current_turret.rotation, _header_helper.rotation, 0.4)
	
