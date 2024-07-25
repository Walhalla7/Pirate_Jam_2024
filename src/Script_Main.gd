extends Node

@onready var dustbunnies = [$Interactable/DustBunny1, $Interactable/DustBunny2, $Interactable/DustBunny3, $Interactable/DustBunny4]
var time :float

#======================================== 	Initialize 	==================================
func _ready():
	pass
	
#======================================== 	Process 	==================================
func _physics_process(delta):
	time += delta
	
	#if player presses escape 
	#TO_DO: Make a menu and UI so that escape opens that menu instead
	if Input.is_action_pressed("Escape"):
		get_tree().quit()
		
	animate_dust_bunnies(delta)

#moves the dustbunny sprites in space
func animate_dust_bunnies(delta):
	var phase = 1
	for bunny in dustbunnies:
		bunny.global_position.x += sin(time*2+phase)/100  #sin(time*frequency+phase)/amplitude
		bunny.global_position.z += sin(time*2+phase)/100  
		phase += 1
