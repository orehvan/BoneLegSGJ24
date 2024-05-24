extends Effect

@export var healing := 20.0

func _start() -> void :
	var parent := get_parent() as RocketHouse
	if parent :
		parent .health += healing
	super._start()

func _finished() -> void :
	super._finished()
