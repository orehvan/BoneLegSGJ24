extends Control

signal  to_main_menu

@onready var _tab_container: TabContainer = %TabContainer

enum Pages {
	Page1,
	Page2,
	Page3,
	Page4,
	Page5,
	Page6,
	Page7,
	Page8,
	Page9,
	Page10,
	Page11,
	Page12,
}

@export var current_page: Pages = Pages.Page1 :
	set(val) :
		
		current_page = val
		_tab_container.current_tab = int(current_page)


func _on_button_next_pressed():
	if int(current_page) < Pages.size() - 1:
		current_page += 1
		_tab_container.current_tab = int(current_page)


func _on_button_prev_pressed():
	if int(current_page) > 1:
		current_page -= 1
		_tab_container.current_tab = int(current_page)


func _on_button_return_pressed():
	to_main_menu.emit()


func _on_visibility_changed() -> void:
	if visible :
		Global.pause_count += 1
	else :
		Global.pause_count -= 1
