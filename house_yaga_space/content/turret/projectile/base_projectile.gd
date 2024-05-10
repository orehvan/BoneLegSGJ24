extends CharacterBody2D

const ANIM_PLAY := "play"

@export var speed := 100.0
@export var damage := 10.0

@onready var _animation_sprite: AnimatedSprite2D = $AnimatedSprite2D as AnimatedSprite2D
@onready var _renderer: Sprite2D = $Renderer/Sprite as Sprite2D
@onready var _audio_explotion: AudioStreamPlayer2D = $AudioExplotion


var is_dead := false

func _physics_process(delta: float) -> void:
	if is_dead :
		return
	
	var direction := Vector2.RIGHT.rotated(rotation).normalized()
	var motion := direction * speed * delta
	var collision := move_and_collide(motion)
	if collision :
		var object := collision.get_collider()
		if object is EnemyBase :
			object.apply_damage(damage)
		elif object is Planet :
			object.apply_damage(damage)
		
		_animation_sprite.visible = true
		_animation_sprite.play(ANIM_PLAY)
		_renderer.visible = false
		is_dead = true
		_audio_explotion.play()


func _on_timer_life_time_timeout() -> void:
	if is_dead :
		return
	is_dead = true
	_animation_sprite.visible = true
	_animation_sprite.play(ANIM_PLAY)
	_renderer.visible = false
	_audio_explotion.play()


func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
