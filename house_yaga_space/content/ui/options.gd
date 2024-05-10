extends Control

signal to_back()

const BUS_MAIN := "Master"
const BUS_MUSIC := "Music"
const BUS_SFX := "SFX"
const MIN_DB := -80.0
const MAX_DB := 0.0

@onready var _main: HSlider = %HSliderMain
@onready var _music: HSlider = %HSliderMusic
@onready var _sfx: HSlider = %HSliderSFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_bus()

func _update_bus() -> void :
	if _main : 
		_main.set_value_no_signal(get_value_from_bus(BUS_MAIN))
	if _music :
		_music.set_value_no_signal(get_value_from_bus(BUS_MUSIC))
	if _sfx :
		_sfx.set_value_no_signal(get_value_from_bus(BUS_SFX))

func get_value_from_bus(bus_name: String) -> float :
	var idx: int = AudioServer.get_bus_index(bus_name)
	var value: float = AudioServer.get_bus_volume_db(idx)
	if value == 0 :
		return 1.0
	var n: float = 1.0 + (value / MIN_DB)
	return n

func set_value_from_bus(bus_name: String, value: float) -> void :
	var idx: int = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_volume_db(idx, lerpf(MIN_DB, MAX_DB, value))



func _on_button_back_pressed() -> void:
	to_back.emit()


func _on_h_slider_main_value_changed(value: float) -> void:
	set_value_from_bus(BUS_MAIN, value)


func _on_h_slider_music_value_changed(value: float) -> void:
	set_value_from_bus(BUS_MUSIC, value)


func _on_h_slider_sfx_value_changed(value: float) -> void:
	set_value_from_bus(BUS_SFX, value)


func _on_visibility_changed() -> void:
	_update_bus()
	
	if visible :
		Global.pause_count += 1
	else :
		Global.pause_count -= 1
