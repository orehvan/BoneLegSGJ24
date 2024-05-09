extends ParallaxBackground

@onready var _parallax_layer_earth: ParallaxLayer = %ParallaxLayerEarth
@export var min_distance := 1000.0
@export var distance_hide := 1000.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	var camera := get_viewport().get_camera_2d()
	if camera :
		var y_cam_pos := camera.global_position.y
		var y_layer_pos := _parallax_layer_earth.global_position.y
		var y_diff := maxf(0, (y_layer_pos - y_cam_pos) - min_distance)
		var delta_hide := 1.0 - (y_diff / distance_hide)
		_parallax_layer_earth.modulate.a = delta_hide
