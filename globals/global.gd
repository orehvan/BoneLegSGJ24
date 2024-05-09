extends Node

var is_debug := true

var player: Node2D = null
var enemy_count: int = 0
var enemy_limit: int = 100


var player_flying := false

var player_distance_spawn := 3500


const LIST_ENEMY := [
	preload("res://house_yaga_space/content/enemy/enemy_base.tscn")
]


func _physics_process(delta: float) -> void:
	if player_flying and player:
		if enemy_count < enemy_limit :
			var index: int = randi_range(0, LIST_ENEMY.size() - 1)
			var pkg: PackedScene = LIST_ENEMY[index] as PackedScene
			var enemy: Node2D = pkg.instantiate() as Node2D
			
			var direction_from_player_rand := Vector2.LEFT.rotated(randf_range(-TAU, TAU))
			var position_spawn := player.global_position + direction_from_player_rand * player_distance_spawn
			enemy.position = position_spawn
			get_tree().current_scene.add_child(enemy)
			
