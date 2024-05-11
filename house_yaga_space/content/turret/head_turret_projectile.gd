extends HeadTurret


const ANIM_SHOOT := "shoot"

@onready var _targets: Node2D = %Targets
@onready var _timer: Timer = %Timer
@onready var _animation_player: AnimationPlayer = %AnimationPlayer
@onready var _audio_shot: AudioStreamPlayer2D = %AudioShot

@export var projectile_packed: PackedScene = null

func start_shoot() -> void :
	if _timer.is_stopped() :
		_timer.start()

func stop_shoot() -> void :
	if not _timer.is_stopped() :
		_timer.stop()



func _on_shoot() -> void :
	_audio_shot.play()
	for node in _targets.get_children() :
		var target: Marker2D = node as Marker2D
		if target :
			if projectile_packed :
				var projectile: Node2D = projectile_packed.instantiate() as Node2D
				var direction := global_position.direction_to(target.global_position)
				projectile.rotation = direction.angle()
				projectile.position = target.global_position
				get_tree().current_scene.add_child(projectile)


func _on_timer_timeout() -> void:
	_animation_player.play(ANIM_SHOOT)
