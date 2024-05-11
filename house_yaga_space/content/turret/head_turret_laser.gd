extends HeadTurret

const ANIM_SHOOT := &"shoot"
const ANIM_STOP_SHOOT := &"stop_shoot"
const ANIM_PLAY := &"play"
const BOOM_PKG := preload("res://house_yaga_space/content/turret/boom.tscn")

@onready var _targets: Node2D = %Targets
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _line_2d: Line2D = %Line2D
@onready var _raycast: RayCast2D = %RayCast2D

@export var damage: float = 50.0
var _is_active := false

const COUNT := 20
var _boom_list: Array[AnimatedSprite2D] = []
var _iter := 0

func _ready() -> void:
	for i in COUNT :
		var node: AnimatedSprite2D = BOOM_PKG.instantiate() as AnimatedSprite2D
		_boom_list.append(node)
		node.visible = false
		node.top_level = true
		node.connect("animation_finished", node.set_visible.bind(false))
		add_child(node)

func start_shoot() -> void :
	if _animation_player :
		_animation_player.play(ANIM_SHOOT)

func stop_shoot() -> void :
	if _animation_player and _animation_player.is_playing():
		if _animation_player.current_animation != ANIM_STOP_SHOOT :
			_animation_player.play(ANIM_STOP_SHOOT)


func _physics_process(delta: float) -> void:
	if _raycast and _is_active:
		if _raycast.is_colliding() :
			var collide := _raycast.get_collider()
			if collide :
				if collide.has_method(&"apply_damage") :
					collide.apply_damage(damage * delta)
			
			var g_pos := _raycast.get_collision_point()
			var local := _line_2d.to_local(g_pos)
			_line_2d.set_point_position(0, Vector2(local.x, 0))
			
			var boom := _boom_list[_iter]
			boom.visible = true
			boom.global_position = g_pos
			boom.play(ANIM_PLAY)
			_iter += 1
			if _iter >= _boom_list.size() :
				_iter = 0
		else :
			_line_2d.set_point_position(0, Vector2(2048, 0))


func _on_shoot() -> void :
	_is_active = true
	

func _on_stop_shoot() -> void :
	_is_active = false

func _on_timer_timeout() -> void:
	_animation_player.play(ANIM_SHOOT)
