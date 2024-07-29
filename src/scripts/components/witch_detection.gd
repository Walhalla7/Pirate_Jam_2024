extends Node3D

class_name WitchDetector

@export var player : CharacterBody3D
@export var lock_x = true
@export var lock_z = false

@onready var ray_cast_3d = $RayCast3D
@onready var timer = $Timer
@onready var hand = $CanvasLayer/Sprite2D
@onready var offscreen_point = $CanvasLayer/Offscreen
@onready var onscreen_point = $CanvasLayer/Onscreen

var caught = false
var looking_at_you = false
var t = 0.0


# TO USE: Set the player to collision mask 1 and anything they can hide behind on collision layer 6
# Connect assign player in the inspector

# Called when the node enters the scene tree for the first time.
func _ready():
	ray_cast_3d.global_position = player.global_position
	ray_cast_3d.global_position.z = 5
	timer.wait_time = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# Follow the player left and right
	ray_cast_3d.global_position.x = player.global_position.x
	# Follow the player up and down
	ray_cast_3d.global_position.y = player.global_position.y
	
	if ray_cast_3d.is_colliding(): 
		if ray_cast_3d.get_collider() == player && looking_at_you == false:
			timer.start()
			looking_at_you = true
		elif ray_cast_3d.get_collider() != player || ray_cast_3d.is_colliding() == false:
			timer.stop()
			looking_at_you = false
	elif ray_cast_3d.is_colliding() == false:
		timer.stop()
		looking_at_you = false

	if caught == true:
		# This changes speed 
		t += delta * 0.2
		
		hand.position = hand.position.lerp(onscreen_point.position, t)
		#hand.position = hand.position.lerp(offscreen_point.position, t)
		#player.visible = false

#func move_hand(delta):
	#t += delta * 0.4
	#print("move hand called")
	#hand.position = offscreen_point.position.lerp(onscreen_point.position, t)
	
func _on_timer_timeout():
	caught = true
