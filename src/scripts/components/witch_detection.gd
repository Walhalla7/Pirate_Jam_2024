extends Node3D

class_name WitchDetector

@export var player : CharacterBody3D
@export var lock_x = true
@export var lock_z = false

@onready var ray_cast_3d = $RayCast3D
@onready var timer = $Timer
@onready var hand = $CanvasLayer/Sprite2D
@onready var point_a = $CanvasLayer/PointA
@onready var point_b = $CanvasLayer/PointB

var caught = false
var t = 0.0

# TO USE: Set the player to collision mask 1 and anything they can hide behind on collision layer 6
# Connect assign player in the inspector

# Called when the node enters the scene tree for the first time.
func _ready():
	ray_cast_3d.global_position = player.global_position
	ray_cast_3d.global_position.z = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Follow the player left and right
	ray_cast_3d.global_position.x = player.global_position.x
	# Follow the player up and down
	ray_cast_3d.global_position.y = player.global_position.y
	
	if ray_cast_3d.is_colliding():
		#print(str(ray_cast_3d.get_collider()))
		
		if ray_cast_3d.get_collider() == player:
			timer.start()
			
			print("start")
			print(str(timer.time_left))
		elif ray_cast_3d.get_collider() != player || ray_cast_3d.is_colliding() == false:
			timer.stop()
			print("stop")
			
	if caught:
		print("caught")
		move_hand(delta)
		caught = false


func move_hand(delta):
	t += delta * 0.4
	hand.position = point_a.position.lerp(point_b.position, t)
	

func _on_timer_timeout():
	caught = true
