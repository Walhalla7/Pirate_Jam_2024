extends Node3D

@onready var camera_3d = $Camera3D

@export var camera_target : CharacterBody3D
@export var lock_x = true
@export var lock_z = false

# changes what wall we are looking at
func change_wall():
	if lock_x:
		lock_x = false
		lock_z = true
	elif lock_z:
		lock_z = false
		lock_x = true
		

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Which direction we are facing, lock that angle and follow the player left to right
	if lock_x:
		camera_3d.global_position.z = camera_target.global_position.z
	elif lock_z:
		camera_3d.global_position.x = camera_target.global_position.x
	
	# Follow the player up and down
	camera_3d.global_position.y = camera_target.global_position.y + 1
