extends CharacterBody3D

#Camera managment
@onready var camera_target = $CameraTarget
@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var sprite_3d = $Sprite3D

#======================================== 	Detectors 	==================================
@onready var floorDetectors = $Raycasts/Floor_detectors
var is_Grounded

func _check_is_grounded():
	for raycast in floorDetectors.get_children():
		if raycast.is_colliding():
			return true
	return false

@onready var rightDetector = $Raycasts/Right_detector
@onready var leftDetector = $Raycasts/Left_detector
@onready var backDetector = $Raycasts/Back_detector

#======================================== 	Variables 	==================================
#Movement variables
const move_speed = 5.0
const JUMP_VELOCITY = 7
var sprint_modifier = 1

# Gravity
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") #Get the gravity from the project settings to be synced with RigidBody nodes.
var gravityStrength = 9.8

#======================================== 	Hurt & Death Functions 	==================================\

func _on_health_component_death():
	print("Player has died")

func _on_health_component_hurt():
	print("Player has been hurt")

#======================================== 	Movement 	==================================
#Gravity applied universally
func _apply_gravity(delta):
	velocity.y -= gravityStrength * delta

func _apply_movement():
	is_Grounded = _check_is_grounded()
	
	# Flip Sprite
	if velocity.x > 0:
		animated_sprite_3d.flip_h = true
	elif velocity.x < 0:
		animated_sprite_3d.flip_h = false
		
	move_and_slide()


#function to calulcate directional inputs and movements 
func _handle_move_input():
	#we calculate movement direction based on inputs 
	var move_direction_x = int(Input.is_action_pressed("move_left")) - int(Input.is_action_pressed("move_right"))
	var move_direction_z = int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
	
	#Sprint Input / calculations
	sprint_modifier = 2 if Input.is_action_pressed("sprint") else 1
	
	#we apply the direction to velocity 
	velocity.x = lerp(velocity.x, move_direction_x * move_speed * sprint_modifier, _get_h_weight())
	velocity.z = lerp(velocity.z, move_direction_z * move_speed * sprint_modifier, _get_h_weight())
	
	#we apply animations/rotate sprite
	if move_direction_x != 0 or move_direction_z != 0:
		animated_sprite_3d.play("walk")	
		if velocity.x < 0:
			$Sprite3D.rotation.y = -PI
		else: 
			$Sprite3D.rotation.y = 0
		
		if velocity.z < 0:
			$Sprite3D.rotation.y = -0.5
		else:
			$Sprite3D.rotation.y = 0.5
	else:
		animated_sprite_3d.play("idle")

#function to calulcate directional inputs and movements on left wall
func _handle_move_Left_input():
	#we calculate movement direction based on inputs 
	var move_direction_y
	var move_direction_x
	var move_direction_z
	
	if is_Grounded:
		move_direction_y = int(Input.is_action_pressed("move_left"))
		move_direction_x = -int(Input.is_action_pressed("move_right"))
	else:
		move_direction_y = int(Input.is_action_pressed("move_left")) - int(Input.is_action_pressed("move_right"))
	move_direction_z = int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
	
	#Sprint Input / calculations
	sprint_modifier = 2 if Input.is_action_pressed("sprint") else 1
	
	#we apply the direction to velocity 
	if is_Grounded:
		velocity.x = lerp(velocity.x, move_direction_x * move_speed * sprint_modifier, _get_h_weight())
	velocity.y = lerp(velocity.y, move_direction_y * move_speed * sprint_modifier, _get_h_weight())
	velocity.z = lerp(velocity.z, move_direction_z * move_speed * sprint_modifier, _get_h_weight())

#function to calulcate directional inputs and movements on right wall
func _handle_move_Right_input():
	var move_direction_y
	var move_direction_x
	var move_direction_z
	
	#we calculate movement direction based on inputs 
	if is_Grounded:
		move_direction_x = int(Input.is_action_pressed("move_left"))
		move_direction_y = int(Input.is_action_pressed("move_right"))
	else:
		move_direction_y = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
	move_direction_z = int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
	
	#Sprint Input / calculations
	sprint_modifier = 2 if Input.is_action_pressed("sprint") else 1
	
	#we apply the direction to velocity 
	if is_Grounded:
		velocity.x = lerp(velocity.x, move_direction_x * move_speed * sprint_modifier, _get_h_weight())
	velocity.y = lerp(velocity.y, move_direction_y * move_speed * sprint_modifier, _get_h_weight())
	velocity.z = lerp(velocity.z, move_direction_z * move_speed * sprint_modifier, _get_h_weight())

#function to calulcate directional inputs and movements on right wall
func _handle_move_Back_input():
	var move_direction_y
	var move_direction_x
	var move_direction_z
	
	#we calculate movement direction based on inputs 
	if is_Grounded:
		move_direction_z = -int(Input.is_action_pressed("move_forward"))
		move_direction_y = int(Input.is_action_pressed("move_back"))
	else:
		move_direction_y = int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
	move_direction_x = int(Input.is_action_pressed("move_left")) - int(Input.is_action_pressed("move_right"))
	
	#Sprint Input / calculations
	sprint_modifier = 2 if Input.is_action_pressed("sprint") else 1
	
	#we apply the direction to velocity 
	if is_Grounded:
		velocity.z = lerp(velocity.z, move_direction_z * move_speed * sprint_modifier, _get_h_weight())
	velocity.y = lerp(velocity.y, move_direction_y * move_speed * sprint_modifier, _get_h_weight())
	velocity.x = lerp(velocity.x, move_direction_x * move_speed * sprint_modifier, _get_h_weight())

#turning strength based on being on the floor
func _get_h_weight():
	return 0.2 if is_Grounded else 0.1

#======================================== 	Initialize 	==================================
func _ready():
	pass

#======================================== 	Process 	==================================
func _physics_process(delta):
	pass


