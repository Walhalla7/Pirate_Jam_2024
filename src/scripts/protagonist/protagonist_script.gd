extends CharacterBody3D

#Camera managment
@onready var camera_target = $CameraTarget
@onready var animated_sprite_3d = $AnimatedSprite3D

#clibable detectors
@onready var floor_detector = $Floor_Detector
@onready var righ_detector = $Right_Detector
@onready var left_detector = $Left_Detector
@onready var back_detector = $Back_Detector
@onready var crawl_timer = $Crawl_Timer

@export var slideDownForce = 2
@export var slowDownOnWall = 3


#======================================== 	States 	==================================
#current state of the player
var curr_State

#States player can be in 
#WORK IN PROGRESS
#TO DO: Implement camera changing and detection of wall to which player is attached
enum States {
	FLOOR,
	WALL_BACK,
	WALL_LEFT,
	WALL_RIGHT,
	FALLING
}


#called when snail been on the wall too long
func _on_crawl_timer_timeout():
	can_crawl = false

#checking if snail is currently climbing
func _is_timer_active():
	if (crawl_timer.time_left > 0):
		return true
	else:
		return false


#Call this function whenever the snail changes it's state along with the state you want to change it to
func change_State(newState:States):
	match newState:
		States.FLOOR:
			if curr_State != States.FLOOR:
				can_crawl = true
				crawl_timer.stop()
				curr_State = States.FLOOR
				print("Floor")	
		States.WALL_BACK:
			if curr_State != States.WALL_BACK:
				if !_is_timer_active():
					crawl_timer.start()
				curr_State = States.WALL_BACK
				print("WALL_BACK")	
		States.WALL_LEFT:
			if curr_State != States.WALL_LEFT:
				if !_is_timer_active():
					crawl_timer.start()
				curr_State = States.WALL_LEFT
				print("WALL_LEFT")	
		States.WALL_RIGHT:
			if curr_State != States.WALL_RIGHT:
				if !_is_timer_active():
					crawl_timer.start()
				curr_State = States.WALL_RIGHT
				print("WALL_RIGHT")	
		States.FALLING:
			if curr_State != States.FALLING:
				curr_State = States.FALLING
				print("FALLING")	

#======================================== 	Variables 	==================================
#Movement variables
const speed = 5.0
var target_velocity = Vector3.ZERO
const JUMP_VELOCITY = 7
var sprint_modifier = 1
var can_crawl = true

# Gravity
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") #Get the gravity from the project settings to be synced with RigidBody nodes.
var gravityStrength = 9.8
			
#======================================== 	Hurt & Death Functions 	==================================\

func _on_health_component_death():
	print("Player has died")

func _on_health_component_hurt():
	print("Player has been hurt")
	
#======================================== 	Initialize 	==================================
func _ready():
	pass

#======================================== 	Process 	==================================
func _physics_process(delta):
	#base direction
	var direction = Vector3.ZERO
	
	#Determining States
	if left_detector.is_colliding():
		change_State(States.WALL_LEFT)
	elif righ_detector.is_colliding():
		change_State(States.WALL_RIGHT)
	elif back_detector.is_colliding():
		change_State(States.WALL_BACK)
	elif floor_detector.is_colliding():
		change_State(States.FLOOR)
	else:
		change_State(States.FALLING)
	
	if curr_State != States.FLOOR:
		target_velocity.y -= gravityStrength * delta
	
	match curr_State:
		States.FALLING:
			
			if Input.is_action_pressed("move_right"):
				direction.x -= 1
				$Sprite3D.rotation.y = 0
			if Input.is_action_pressed("move_left"):
				direction.x += 1
				$Sprite3D.rotation.y = -PI
			if Input.is_action_pressed("move_forward"):
				direction.z -= 1
				$Sprite3D.rotation.y = -0.5
			if Input.is_action_pressed("move_back"):
				direction.z += 1
				$Sprite3D.rotation.y = 0.5
				
			target_velocity.x = direction.x * speed * sprint_modifier
			target_velocity.z = direction.z * speed * sprint_modifier

		States.FLOOR:
			if Input.is_action_pressed("move_right"):
				direction.x -= 1
				$Sprite3D.rotation.y = 0
			if Input.is_action_pressed("move_left"):
				direction.x += 1
				$Sprite3D.rotation.y = -PI
			if Input.is_action_pressed("move_forward"):
				direction.z -= 1
				$Sprite3D.rotation.y = -0.5
			if Input.is_action_pressed("move_back"):
				direction.z += 1
				$Sprite3D.rotation.y = 0.5
			if Input.is_action_just_pressed("jump"):
				target_velocity.y = JUMP_VELOCITY
			target_velocity.x = direction.x * speed * sprint_modifier
			target_velocity.z = direction.z * speed * sprint_modifier
				
		States.WALL_RIGHT:
			if Input.is_action_pressed("move_right") && can_crawl:
				direction.y += 1
				$Sprite3D.rotation.y = 0
			if Input.is_action_pressed("move_left") or back_detector.is_colliding():
				if floor_detector.is_colliding():
					direction.x += 1
					$Sprite3D.rotation.y = -PI
					target_velocity.x = direction.x * speed * sprint_modifier
				else:
					direction.y -= 1
					$Sprite3D.rotation.y = -PI
			if Input.is_action_pressed("move_forward"):
				direction.z -= 1
				$Sprite3D.rotation.y = -0.5
			if Input.is_action_pressed("move_back"):
				direction.z += 1
				$Sprite3D.rotation.y = 0.5
				
			if Input.is_action_just_pressed("jump"):
				target_velocity.x = JUMP_VELOCITY
				target_velocity.y = JUMP_VELOCITY 
			
			# Adjust gravity for climbing
			target_velocity.y = direction.y * speed/slowDownOnWall * sprint_modifier - gravityStrength * slideDownForce * delta
			target_velocity.z = direction.z * speed/slowDownOnWall * sprint_modifier
			
			
		
		States.WALL_LEFT:
			if Input.is_action_pressed("move_right"):
				if floor_detector.is_colliding() or back_detector.is_colliding():
					direction.x -= 1
					$Sprite3D.rotation.y = 0
					target_velocity.x = direction.x * speed * sprint_modifier
				else:
					direction.y -= 1
					$Sprite3D.rotation.y = 0
			if Input.is_action_pressed("move_left") && can_crawl:
				direction.y += 1
				$Sprite3D.rotation.y = -PI
			if Input.is_action_pressed("move_forward"):
				direction.z -= 1
				$Sprite3D.rotation.y = -0.5
			if Input.is_action_pressed("move_back"):
				direction.z += 1
				$Sprite3D.rotation.y = 0.5
			if Input.is_action_just_pressed("jump"):
				target_velocity.x = -JUMP_VELOCITY
			target_velocity.y = direction.y * speed/slowDownOnWall  * sprint_modifier - (gravityStrength*slideDownForce * delta) 
			target_velocity.z = direction.z * speed/slowDownOnWall  * sprint_modifier
		
		States.WALL_BACK:
			if Input.is_action_pressed("move_right"):
				direction.x -= 1
			if Input.is_action_pressed("move_left"):
				direction.x += 1
			if Input.is_action_pressed("move_forward"):
				if floor_detector.is_colliding():
					direction.z -= 1
					target_velocity.z = direction.z * speed/2  * sprint_modifier
				else:
					direction.y -= 1
			if Input.is_action_pressed("move_back") && can_crawl:
				direction.y += 1
			if Input.is_action_just_pressed("jump"):
				target_velocity.z = -JUMP_VELOCITY
			target_velocity.y = direction.y * speed/slowDownOnWall  * sprint_modifier - (gravityStrength*slideDownForce * delta) 
			target_velocity.x = direction.x * speed/slowDownOnWall  * sprint_modifier


	#Sprint Input / calculations
	sprint_modifier = 2 if Input.is_action_pressed("sprint") else 1
	
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Animation Tree
	if direction.x == 0 && direction.z == 0: 
		animated_sprite_3d.play("idle")
	else:
		animated_sprite_3d.play("walk")
		
	# Flip Sprite
	if direction.x > 0:
		animated_sprite_3d.flip_h = true
	elif direction.x < 0:
		animated_sprite_3d.flip_h = false

	# Ground Velocity
	
	
	# Moving the Character
	velocity = target_velocity
	move_and_slide()



