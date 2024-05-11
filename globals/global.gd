extends Node

signal progress_completed()

const LIST_ENEMY := [
	preload("res://house_yaga_space/content/enemy/enemy_1.tscn"),
	preload("res://house_yaga_space/content/enemy/enemy_2.tscn"),
	preload("res://house_yaga_space/content/enemy/enemy_3.tscn"),
	preload("res://house_yaga_space/content/enemy/enemy_4.tscn"),
]

const BONUSES := [
	preload("res://house_yaga_space/content/bonus/bonus.tscn"),
	preload("res://house_yaga_space/content/bonus/bonus_burger.tscn"),
	preload("res://house_yaga_space/content/bonus/bonus_metla.tscn"),
	
]

const STAGE_NEED := 100

var is_debug := false

var player: Node2D = null
var enemy_count: int = 0
var enemy_limit: int = 50


var player_flying: bool = false
var count_spawned: int = 0
var player_distance_spawn: int = 3500

var current_stage: int = 0
var random_chanse_next: float = 0.05
var random_big_variant: float = 0.01

var progress: float = 0.0
var max_killed: int = STAGE_NEED * 2
var total_killed: int = 0

var enable_cursor: bool = false
var target_exit: Node2D = null

var bonus_chanse_elites := 1.0
var bonus_chanse_little := 0.05


var pause_count: int = 0 :
	set(val) :
		pause_count = maxi(0, val)
		print(self, " PAUSE: ", pause_count)
		if is_inside_tree() :
			if get_tree() :
				if val <= 0 :
					get_tree().paused = false
				else :
					get_tree().paused = true



func _physics_process(_delta: float) -> void:
	if player_flying and player:
		if enemy_count < enemy_limit :
			var index: int = min(LIST_ENEMY.size() - 1, current_stage)
			
			var rand_val := randf()
			if rand_val < random_chanse_next :
				index = randi_range(0, LIST_ENEMY.size() - 1)
			
			var pkg: PackedScene = LIST_ENEMY[index] as PackedScene
			var enemy: Node2D = pkg.instantiate() as Node2D
			if rand_val < random_big_variant :
				enemy.scale *= 2.0
				enemy.damage *= 2.0
				enemy.health *= 4.0
				enemy.speed *= 1.2
				if randf() < bonus_chanse_elites :
					enemy.bonus_packed = BONUSES[randi_range(0, BONUSES.size() - 1)]
			else :
				if randf() < bonus_chanse_little :
					enemy.bonus_packed = BONUSES[randi_range(0, BONUSES.size() - 1)]
			
			var direction_from_player_rand := Vector2.LEFT.rotated(randf_range(-TAU, TAU))
			var position_spawn := player.global_position + direction_from_player_rand * player_distance_spawn
			enemy.position = position_spawn
			enemy.tree_exited.connect(_on_dead_enemy)
			get_tree().current_scene.get_current_game().add_child(enemy)
			count_spawned += 1
			if count_spawned > STAGE_NEED :
				count_spawned = 0
				current_stage += 1
			

func reset() -> void :
	
	enemy_count = 0
	player_flying = false
	count_spawned = 0
	current_stage = 0
	random_chanse_next = 0.05
	random_big_variant = 0.01
	progress = 0.0
	total_killed = 0
	enable_cursor = false
	target_exit = null

func _on_dead_enemy() -> void :
	total_killed += 1
	if progress < 1.0 :
		_update_progress()

func _update_progress() -> void :
	progress = clampf(float(total_killed) / float(max_killed), 0.0, 1.0)
	if progress >= 1.0 :
		progress_completed.emit()
