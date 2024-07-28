extends Control

func _ready():
	hide()
	SignalBus.game_over.connect(GameEnd)



# Called when the node enters the scene tree for the first time.
	
func _on_restart_pressed():
	get_parent().find_child("TestWorld").get_tree().reload_current_scene()

	self.hide()

	
func _on_quit_pressed():
	

	get_tree().quit()


func GameEnd():
	show()

