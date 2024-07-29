extends CharacterBody3D

#Camera managment
@onready var camera_target = $CameraTarget
@onready var animated_sprite_3d = $AnimatedSprite3D
@onready var sprite_3d = $Sprite3D
@onready var climbTimer = $ClimbTimer
@onready var animation_player = $AnimationPlayer

#======================================== 	Detectors 	==================================
@onready var floorDetectors = $Raycasts/Floor_detectors
var is_Grounded

#detecting if player is on the floor 
func _check_is_grounded():
	for raycast in floorDetectors.get_children():
		if raycast.is_colliding():
			return true
	return false

#detecting if player is on wall
@onready var rightDetector = $Raycasts/Right_detector
@onready var leftDetector = $Raycasts/Left_detector
@onready var backDetector = $Raycasts/Back_detector

#======================================== 	Variables 	==================================
#Movement variables
@export var move_speed = 5.0
@export var JUMP_VELOCITY = 7
var sprint_modifier = 1
@export var max_sprint_modifier = 2
var can_crawl = true
@export var wall_slowdown = 2
@export var jump_vertical_strength = 9
@export var jump_horizontal_strength = 7
var WALL_JUMP_VELOCITY = Vector3(0,jump_vertical_strength,0)

# Gravity
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") #Get the gravity from the project settings to be synced with RigidBody nodes.
var gravityStrength = 9.8

#======================================== 	Hurt & Death Functions 	==================================\

func _on_health_component_death():
	print("Player has died")
	SignalBus.emit_signal("game_over")

func _on_health_component_hurt():
	print("Player has been hurt")

#======================================== 	Movement 	==================================
#Gravity applied universally
func _apply_gravity(delta):
	velocity.y -= gravityStrength * delta

#called when snail been on the wall too long
func _on_climb_timer_timeout():
	can_crawl = false

#checking if snail is currently climbing
func _is_timer_active():
	if (climbTimer.time_left > 0):
		return true
	else:
		return false

#smooth out movement and perform checks on whether the player is grounded or not
func _apply_movement():
	is_Grounded = _check_is_grounded()
	
	# Flip Sprite
	if velocity.x > 0:
		animated_sprite_3d.flip_h = true
	elif velocity.x < 0:
		animated_sprite_3d.flip_h = false
		
	move_and_slide()

#wall jump calulculations function
func wall_jump():
	var wall_jump_velocity = WALL_JUMP_VELOCITY
	if rightDetector.is_colliding():
		wall_jump_velocity.x = jump_horizontal_strength
	elif leftDetector.is_colliding():
		wall_jump_velocity.x = -jump_horizontal_strength
	elif backDetector.is_colliding():
		wall_jump_velocity.z = -jump_horizontal_strength
	can_crawl = false
	climbTimer.stop()
	velocity = wall_jump_velocity

#function to calulcate directional inputs and movements 
func _handle_move_input():
	#we calculate movement direction based on inputs 
	var move_direction_x = int(Input.is_action_pressed("move_left")) - int(Input.is_action_pressed("move_right"))
	var move_direction_z = int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
	
	#Sprint Input / calculations
	sprint_modifier = max_sprint_modifier if Input.is_action_pressed("sprint") else 1
	
	#we apply the direction to velocity 
	velocity.x = move_direction_x * move_speed * sprint_modifier
	velocity.z = move_direction_z * move_speed * sprint_modifier
	
	##we apply animations/rotate sprite
	#if move_direction_x != 0 or move_direction_z != 0:
		#animated_sprite_3d.play("walk")	
		#if velocity.x < 0:
			#$Sprite3D.rotation.y = -PI
		#else: 
			#$Sprite3D.rotation.y = 0
		#
		#if velocity.z < 0:
			#$Sprite3D.rotation.y = -0.5
		#else:
			#$Sprite3D.rotation.y = 0.5
	#else:
		#animated_sprite_3d.play("idle")

#function to calulcate directional inputs and movements on left wall
func _handle_move_Left_input():
	#we calculate movement direction based on inputs 
	var move_direction_y
	var move_direction_x
	var move_direction_z
	
	if is_Grounded or backDetector.is_colliding():
		move_direction_y = int(Input.is_action_pressed("move_left"))
		move_direction_x = -int(Input.is_action_pressed("move_right"))
	else:
		if can_crawl:
			move_direction_y = int(Input.is_action_pressed("move_left")) - int(Input.is_action_pressed("move_right"))
		else:
			move_direction_y = - int(Input.is_action_pressed("move_right"))
	move_direction_z = int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
	
	#Sprint Input / calculations
	sprint_modifier = max_sprint_modifier if Input.is_action_pressed("sprint") else 1
	
	#we apply the direction to velocity 
	if is_Grounded:
		velocity.x = lerp(velocity.x, move_direction_x * move_speed * sprint_modifier, _get_h_weight())
	velocity.y = lerp(velocity.y, move_direction_y * (move_speed-wall_slowdown) * sprint_modifier, _get_h_weight())
	velocity.z = lerp(velocity.z, move_direction_z * move_speed * sprint_modifier, _get_h_weight())

#function to calulcate directional inputs and movements on right wall
func _handle_move_Right_input():
	var move_direction_y
	var move_direction_x
	var move_direction_z
	
	#we calculate movement direction based on inputs 
	if is_Grounded or backDetector.is_colliding():
		move_direction_x = int(Input.is_action_pressed("move_left"))
		move_direction_y = int(Input.is_action_pressed("move_right"))
	else:
		if can_crawl:
			move_direction_y = -int(Input.is_action_pressed("move_left")) + int(Input.is_action_pressed("move_right"))
		else:
			move_direction_y = -int(Input.is_action_pressed("move_left"))
	move_direction_z = int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
	
	#Sprint Input / calculations
	sprint_modifier = max_sprint_modifier if Input.is_action_pressed("sprint") else 1
	
	#we apply the direction to velocity 
	if is_Grounded:
		velocity.x = lerp(velocity.x, move_direction_x * move_speed * sprint_modifier, _get_h_weight())
	velocity.y = lerp(velocity.y, move_direction_y * (move_speed-wall_slowdown) * sprint_modifier, _get_h_weight())
	velocity.z = lerp(velocity.z, move_direction_z * move_speed * sprint_modifier, _get_h_weight())

#function to calulcate directional inputs and movements on right wall
func _handle_move_Back_input():
	var move_direction_y
	var move_direction_x
	var move_direction_z
	
	#we calculate movement direction based on inputs 
	if is_Grounded or leftDetector.is_colliding() or rightDetector.is_colliding():
		move_direction_z = -int(Input.is_action_pressed("move_forward"))
		move_direction_y = int(Input.is_action_pressed("move_back"))
	else:
		if can_crawl:
			move_direction_y = int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
		else:
			move_direction_y = - int(Input.is_action_pressed("move_forward"))
	move_direction_x = int(Input.is_action_pressed("move_left")) - int(Input.is_action_pressed("move_right"))
	
	#Sprint Input / calculations
	sprint_modifier = max_sprint_modifier if Input.is_action_pressed("sprint") else 1
	
	#we apply the direction to velocity 
	if is_Grounded:
		velocity.z = lerp(velocity.z, move_direction_z * move_speed * sprint_modifier, _get_h_weight())
	velocity.y = lerp(velocity.y, move_direction_y * (move_speed-wall_slowdown) * sprint_modifier, _get_h_weight())
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

