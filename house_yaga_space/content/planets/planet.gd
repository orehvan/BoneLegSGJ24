@tool
class_name Planet
extends StaticBody2D

@onready var _sprite: Sprite2D = $Sprite2D as Sprite2D
@onready var _area_2d: Area2D = $Area2D as Area2D
@onready var _collision_shape: CollisionShape2D = $Area2D/CollisionShape2D as CollisionShape2D
@onready var _shape: CircleShape2D = _collision_shape.shape as CircleShape2D

@onready var _collision_shape_static: CollisionShape2D = $CollisionShape2D as CollisionShape2D
@onready var _shape_static: RectangleShape2D = _collision_shape_static.shape as RectangleShape2D

@onready var _animation_player: AnimationPlayer = $AnimationPlayer as AnimationPlayer
@onready var _animation_explotion: AnimatedSprite2D = $AnimExplotion as AnimatedSprite2D

@onready var _audio_explotion: AudioStreamPlayer2D = $AudioExplotion
@onready var _audio_hit: AudioStreamPlayer2D = $AudioHit

const ANIM_SHAKE := "shake"
const ANIM_PLAY := "play"

const TEXTURES: Array[Texture]= [
	preload("res://house_yaga_space/resource/background/Planet_0.png"), 
	preload("res://house_yaga_space/resource/background/Planet_1.png"),
	preload("res://house_yaga_space/resource/background/Planet_2.png"),
	preload("res://house_yaga_space/resource/background/Planet_3.png"),
	
	preload("res://house_yaga_space/resource/space/planet_5.tres"),
	
	preload("res://house_yaga_space/resource/space_tex/space.sprites/space/Planets/cheese_planet.tres"),
	preload("res://house_yaga_space/resource/space_tex/space.sprites/space/Planets/minecraft_planet.tres"),
]

const SIZES: Array[float] = [
	100.0, #0
	150.0, #1
	200.0, #2
	150.0, #3
	150.0, #4
	150.0, #5
	200.0, #6
]

const GRAVITYES: Array[float] = [
	420.0, #0
	420.0, #1
	420.0, #2
	420.0, #3
	420.0, #4
	420.0, #5
	420.0, #6
]

const STATIC_SHAPE_SIZES: Array[Vector2] = [
	Vector2(48, 48), #0
	Vector2(40, 40), #1
	Vector2(52, 52), #2
	Vector2(92, 92), #3
	Vector2(92, 92), #4
	Vector2(92, 92), #5
	Vector2(92, 92), #6
]

const STATIC_SHAPE_OFFSET: Array[Vector2] = [
	Vector2(0,24), #0
	Vector2(0,0), #1
	Vector2(2,2), #2
	Vector2(2,-2), #3
	Vector2(0,-18), #4
	Vector2(2,2), #5
	Vector2(-2,14), #6
]

const MAX_IDX: int = 6

@export_range(0, MAX_IDX) var idx_type: int = 0
@export var health: float = 100.0 :
	set(val) :
		health = val
		if health <= 0.0 :
			_death()

@export var is_random: bool = true
@export var gen: bool = false :
	set(val) :
		gen = false
		if val :
			_gen()
		update_configuration_warnings()

var is_dead := false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if is_random :
		idx_type = randi_range(0, MAX_IDX)
	_gen()
	

func _gen() -> void :
	if _sprite :
		_sprite.texture = TEXTURES[idx_type]
	if _area_2d : 
		_area_2d.gravity = GRAVITYES[idx_type]
		_area_2d.gravity_point_unit_distance = SIZES[idx_type] * 2.0
	if _shape :
		_shape.radius = SIZES[idx_type]
	
	if _collision_shape_static :
		_collision_shape_static.position = STATIC_SHAPE_OFFSET[idx_type]
	if _shape_static :
		_shape_static.size = STATIC_SHAPE_SIZES[idx_type]
	pass

func apply_damage(val: float) -> void :
	if not _animation_player.is_playing() :        
		_animation_player.play(ANIM_SHAKE)
	health -= val
	if not is_dead :
		_audio_hit.play()

func _death() -> void :
	if is_dead :
		return
	is_dead = true
	_animation_explotion.visible = true
	_animation_explotion.play(ANIM_PLAY)
	_audio_explotion.play()
	pass


func _on_anim_explotion_animation_finished() -> void:
	queue_free()
