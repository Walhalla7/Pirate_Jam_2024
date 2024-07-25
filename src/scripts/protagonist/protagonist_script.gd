extends CharacterBody3D

#Camera managment
@onready var camera_target = $CameraTarget
@onready var animated_sprite_3d = $AnimatedSprite3D


#======================================== 	Variables 	==================================
#Movement variables
const move_speed = 5.0
const JUMP_VELOCITY = 7
const LERP_VAL = 0.2
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
#func _apply_movement():
	

func _apply_gravity(delta):
	velocity.y += gravityStrength * delta

func _get_input():
	#we calculate movement direction based on inputs 
	var move_direction_x = int(Input.is_action_pressed("move_left")) - int(Input.is_action_pressed("move_right"))
	var move_direction_z = int(Input.is_action_pressed("move_back")) - int(Input.is_action_pressed("move_forward"))
	
	#Sprint Input / calculations
	sprint_modifier = 2 if Input.is_action_pressed("sprint") else 1
	
	#we apply the direction to velocity 
	velocity.x = lerp(velocity.x, move_direction_x * move_speed * sprint_modifier, LERP_VAL)
	velocity.z = lerp(velocity.z, move_direction_z * move_speed * sprint_modifier, LERP_VAL)
	
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
#======================================== 	Initialize 	==================================
func _ready():
	pass

#======================================== 	Process 	==================================
func _physics_process(delta):
	_get_input()
	
	# Flip Sprite
	if velocity.x > 0:
		animated_sprite_3d.flip_h = true
	elif velocity.x < 0:
		animated_sprite_3d.flip_h = false
		
	move_and_slide()
