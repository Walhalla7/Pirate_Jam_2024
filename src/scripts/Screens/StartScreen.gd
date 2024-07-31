extends Control

#Preloading Scene
var main = preload("res://world.tscn")
var intro = preload("res://intro.tscn")

#Show at the beginning
func _ready():
	SignalBus.intro_done.connect(_on_intro_done)
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	show()

#starting Game
func _on_start_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	hide()
	#initialize intro scene
	var intro_instance = intro.instantiate()
	get_parent().add_child(intro_instance)

	
func _on_intro_done():
	var newLevel_instance = main.instantiate()
	get_parent().add_child(newLevel_instance)
