extends Node

@onready var dustbunnies = [$Interactable/DustBunny1, $Interactable/DustBunny2, $Interactable/DustBunny3, $Interactable/DustBunny4]
var time :float
@onready var cauldron_poisoned = false

#variable declarations for intro
@onready var CauldronCamera = $CauldronCamera


#outro variables (the code will be bad deal with it)
@onready var cauldron_camera = $CauldronCamera
var transition_speed :float
var position_difference :float



#======================================== 	Initialize 	==================================
func _ready():
	pass
	
#======================================== 	Process 	==================================
func _physics_process(delta):
	time += delta
	if cauldron_poisoned:
		transition_speed += delta/100
		cauldron_camera.transform = cauldron_camera.transform.interpolate_with($CauldronCamera2.transform, transition_speed)
		#interpolate cam to cauldron
		
		#positional diff check
		#color change + bubble color change
		#signal emit: SignalBus.emit_signal("Victory")
		pass
	animate_dust_bunnies(delta)

#moves the dustbunny sprites in space
func animate_dust_bunnies(delta):
	var phase = 1
	for bunny in dustbunnies:
		bunny.global_position.x += sin(time*2+phase)/100  #sin(time*frequency+phase)/amplitude
		bunny.global_position.z += sin(time*2+phase)/100  
		phase += 1


func _on_cauldron_zone_body_entered(body):
	if body.is_in_group("Slug"):
		SignalBus.emit_signal("game_over")
		
	if body.is_in_group("Poison"):
		cauldron_poisoned = true
