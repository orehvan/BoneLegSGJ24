class_name EnemyBase
extends CharacterBody2D

const ANIM_HIT := "hit"
const ANIM_DEAD := "dead"

@onready var _audio_hit: AudioStreamPlayer2D = $AudioHit
@onready var _audio_dead: AudioStreamPlayer2D = $AudioDead
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _timer_reload: Timer = $TimerReload

const CAT_DEAD_MEW: Array[AudioStream] = [
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_a.wav"),
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_asharp.wav"),
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_c2.wav"),
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_c.wav"),
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_csharp.wav"),
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_d.wav"),
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_dsharp.wav"),
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_e.wav"),
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_f.wav"),
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_fsharp.wav"),
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_g.wav"),
	preload("res://house_yaga_space/resource/audio/SFX/cat_meow_gsharp.wav"),
]

@export var speed: float = 300.0
@export var random_speed: float = 400.0
@export var damage: float = 10.0
@export var teleport_distance_limit := 4096.0
@export var enable_look_at := false
@export var bonus_packed: PackedScene = null


@export var health: float = 10.0 :
	set(val) :
		health = val
		if health <= 0 :
			death()

var is_dead := false
var _player_detected: Node2D = null

func _ready() -> void:
	speed = speed + randf_range(-random_speed, random_speed)

func _enter_tree() -> void:
	Global.enemy_count += 1

func _exit_tree() -> void:
	Global.enemy_count -= 1

func apply_damage(val: float) -> void :
	health -= val
	if not is_dead :
		_animation_player.play(ANIM_HIT)
		_audio_hit.play()

func death() -> void :
	if is_dead :
		return
	is_dead = true
	
	_animation_player.play(ANIM_DEAD)
	var id_meow := randi_range(0, CAT_DEAD_MEW.size() - 1)
	_audio_dead.stream = CAT_DEAD_MEW[id_meow]
	_audio_dead.play()

func _physics_process(delta: float) -> void:
	if is_dead :
		return
	var player := Global.player
	if player :
		if enable_look_at :
			look_at(player.global_position)
		var direction := global_position.direction_to(player.global_position)
		
		var distance := global_position.distance_to(player.global_position)
		if distance > teleport_distance_limit :
			var new_position := player.global_position + direction * Global.player_distance_spawn
			global_position = new_position
		
		var motion := speed * delta * direction
		velocity = motion
		move_and_slide()


func _on_audio_dead_finished() -> void:
	if bonus_packed :
		var bonus := bonus_packed.instantiate() as Node2D
		bonus.position = position
		get_tree().current_scene.get_current_game().add_child(bonus)
	queue_free()


func _on_area_2d_damage_body_entered(body: Node2D) -> void:
	if body is RocketHouse :
		body.apply_damage(damage)
		_timer_reload.start()
		_player_detected = body
		apply_damage(10.0)


func _on_timer_reload_timeout() -> void:
	if _player_detected :
		_player_detected.apply_damage(damage)
		apply_damage(10.0)
	else :
		_timer_reload.stop()


func _on_area_2d_damage_body_exited(_body: Node2D) -> void:
	_timer_reload.stop()
	_player_detected = null
