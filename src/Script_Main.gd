extends Node

#======================================== 	Initialize 	==================================
func _ready():
	pass
	
#======================================== 	Process 	==================================
func _physics_process(delta):
	#if player presses escape 
	#TO_DO: Make a menu and UI so that escape opens that menu instead
	if Input.is_action_pressed("Escape"):
		get_tree().quit()
