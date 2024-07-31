extends Node

@onready var dustbunnies = [$Interactable/DustBunny1, $Interactable/DustBunny2, $Interactable/DustBunny3, $Interactable/DustBunny4]
var time :float


#variable declarations for intro
@onready var CauldronCamera = $CauldronCamera

#======================================== 	Initialize 	==================================
func _ready():
	#lock movement
	#set camera to cauldron area
	CauldronCamera.current = true
	#slug jar wiggle
	
	
	#WHEN READY:
	#protag position = starting game start pos
	#camera active = protag camera
	#unlock movement

	
#======================================== 	Process 	==================================
func _physics_process(delta):
	time += delta
	
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
		SignalBus.emit_signal("Victory")
