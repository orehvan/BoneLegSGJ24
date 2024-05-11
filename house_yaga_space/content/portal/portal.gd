extends Node2D

@onready var _audio_teleport: AudioStreamPlayer = $AudioStreamPlayer2DTeleport

signal player_entered()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is RocketHouse :
		player_entered.emit()
		queue_free()
		Global.target_exit = null
		Global.enable_cursor = false
		_audio_teleport.play()
