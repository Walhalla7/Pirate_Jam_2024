extends Node3D

class_name WitchDetector

@export var player : CharacterBody3D
@export var lock_x = true
@export var lock_z = false

@onready var ray_cast_3d = $RayCast3D
@onready var timer = $Timer

# TO USE: Set the player to collision mask 1 and anything they can hide behind on collision layer 6

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Foll
	ray_cast_3d.global_position.x = player.global_position.x
	# Follow the player up and down
	ray_cast_3d.global_position.y = player.global_position.y
	
	
	if ray_cast_3d.is_colliding():
		print(str(ray_cast_3d.get_collider()))
	
