class_name EnemyBase
extends CharacterBody2D

@export var speed: float = 300.0
@export var random_speed: float = 400.0
@export var damage: float = 10.0
@export var teleport_distance_limit := 4096.0
@export var enable_look_at := false

@export var health: float = 10.0 :
	set(val) :
		health = val
		if health <= 0 :
			death()

func _ready() -> void:
	speed = speed + randf_range(-random_speed, random_speed)

func _enter_tree() -> void:
	Global.enemy_count += 1

func _exit_tree() -> void:
	Global.enemy_count -= 1

func apply_damage(val: float) -> void :
	health -= val

func death() -> void :
	queue_free()

func _physics_process(delta: float) -> void:
	var player := Global.player
	if player :
		if enable_look_at :
			look_at(player.global_position)
		var direction := global_position.direction_to(player.global_position)
		
		var distance := global_position.distance_to(player.global_position)
		if distance > teleport_distance_limit :
			var diretion_from_player := player.global_position.direction_to(global_position)
			var new_position := player.global_position + direction * Global.player_distance_spawn
			global_position = new_position
		
		var motion := speed * delta * direction
		velocity = motion
		move_and_slide()
