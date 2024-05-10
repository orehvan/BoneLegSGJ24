extends Control

signal to_pause()

@onready var _health: ProgressBar = %Health
@onready var _progress: ProgressBar = %Progress

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Global.player :
		var player := Global.player as RocketHouse
		_health.max_value = player.max_health
		_health.value = player.health
		_progress.value = Global.progress
