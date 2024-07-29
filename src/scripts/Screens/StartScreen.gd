extends Control

#Preloading Scene
var main = preload("res://world.tscn")

#Show at the beginning
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()

#starting Game
func _on_start_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	hide()
	var newLevel_instance = main.instantiate()
	get_parent().add_child(newLevel_instance)
