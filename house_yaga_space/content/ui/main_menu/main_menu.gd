extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://house_yaga_space/content/proto_scene/proto_scene.tscn")

func _on_options_button_pressed():
	get_node("TextureRect/Panel/menu/main_container").visible = false
	get_node("TextureRect/Panel/menu/options_container").visible = true


func _on_quit_button_pressed():
	get_tree().quit()


func _on_return_to_main_button_pressed():
	get_node("TextureRect/Panel/menu/options_container").visible = false
	get_node("TextureRect/Panel/menu/main_container").visible = true
