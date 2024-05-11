class_name Boss
extends CharacterBody2D

@onready var _tentacles: Node2D = $Renderer/Tentacles
@onready var _progress: ProgressBar = $ProgressBar
@onready var _lasers: Node2D = $Lasers
@onready var _timer: Timer = $TimerLaser
@onready var _animation_player: AnimationPlayer = $AnimationPlayer
@onready var _timer_damage: Timer = $TimerDamage

@onready var _audio_hit: AudioStreamPlayer2D = $AudioStreamPlayer2DHit
@onready var _audio_idle: AudioStreamPlayer2D = $AudioStreamPlayer2DIdle
@onready var _audio_death: AudioStreamPlayer2D = $AudioStreamPlayer2DDeath


@export var speed := 250.0
@export var contact_damage := 10.0
@export var laser_damage := 50.0
@export var health := 2000.0 :
	set(val) :
		health = val
		if health <= 0 :
			_death()

@export var laser_active := false

var _started := false
var boss_dead := false

func _ready() -> void:
	pass

func start() -> void :
	_start_animation()
	_timer.start()
	_started = true
	_audio_idle.play()

func _start_animation() -> void :
	for node in _tentacles.get_children() :
		if node is Node2D :
			var tween := get_tree().create_tween()
			tween.tween_property(node, "rotation_degrees", 20.0 + node.rotation_degrees, randf_range(0.5, 1.0))
			tween.tween_property(node, "rotation_degrees", -20.0 + node.rotation_degrees, randf_range(0.5, 1.0))
			tween.set_loops(1000)
	
	

func apply_damage(damage: float) -> void :
	health -= damage
	_audio_hit.play()

func _physics_process(delta: float) -> void:
	if boss_dead :
		return
	if Global.player and _started :
		var direction := global_position.direction_to(Global.player.global_position)
		var vel := direction * speed * delta
		var collide := move_and_collide(vel)
		if collide :
			if _timer_damage.is_stopped() :
				var collider := collide.get_collider()
				if collider is RocketHouse :
					collider.apply_damage(contact_damage)
					_timer_damage.start()
		
	if laser_active :
		for laser in _lasers.get_children() :
			if laser is RayCast2D :
				if laser.is_colliding() :
					var collider = laser.get_collider()
					if collider is RocketHouse :
						collider.apply_damage(laser_damage * delta)
	_progress.value = health

func _death() -> void :
	if boss_dead :
		return
	boss_dead = true
	
	var tween := get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	_audio_death.play()
	_animation_player.stop()
	_timer_damage.stop()
	await  get_tree().create_timer(2.0).timeout
	get_tree().current_scene.get_ui().victory_menu()


func _on_timer_laser_timeout() -> void:
	_animation_player.play("laser")
