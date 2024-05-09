extends Node2D

@onready var _player_rocket_house := %RocketHouse
@onready var _rocket_spawn := %RocketSpawn

var _is_start := false

func _on_button_pressed() -> void:
	if _is_start :
		return
	
	var rocket_on_attach_list: Array[RocketPartEngine] = []
	
	for i in _rocket_spawn.get_child_count() :
		var node := _rocket_spawn.get_child(i) as RocketPartEngine
		if node :
			if node.is_on_player() :
				rocket_on_attach_list.append(node)
	
	if rocket_on_attach_list.is_empty() :
		return
	
	_player_rocket_house.attack_rocket_engine_from_list(rocket_on_attach_list)
	_player_rocket_house.start_space_house()
	_is_start = true
	
	var camera := get_viewport().get_camera_2d()
	var tween := get_tree().create_tween()
	tween.tween_property(camera, "zoom", Vector2.ONE * 0.5, 3.0)


func _on_dead_zone_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()
