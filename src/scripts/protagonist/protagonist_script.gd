extends CharacterBody3D

#Camera managment
@onready var camera_node = $".."/CameraController
@onready var camera_target = $CameraTarget
@onready var animated_sprite_3d = $AnimatedSprite3D

#======================================== 	States 	==================================
#current state of the player
var curr_State

#States player can be in 
#WORK IN PROGRESS
#TO DO: Implement camera changing and detection of wall to which player is attached
enum States {
	FLOOR,
	WALL_FORWARD,
	WALL_BACK,
	WALL_LEFT,
	WALL_RIGHT,
	CEILING,
	FALLING
}

#Actions player cam take in each state
enum Actions {
	MOVE_LEFT,
	MOVE_RIGHT,
	MOVE_FORWARD,
	MOVE_BACK,
	DASH,
	JUMP,
	IDLE
}

#Call this function whenever the snail changes it's state along with the state you want to change it to
func change_State(newState):
	match newState:
		States.FLOOR:
			curr_State = States.FLOOR
			print("Floor")	
		States.WALL_FORWARD:
			curr_State = States.WALL_FORWARD
			print("WALL_FORWARD")	
		States.WALL_BACK:
			curr_State = States.WALL_BACK
			print("WALL_BACK")	
		States.WALL_LEFT:
			curr_State = States.WALL_LEFT
			print("WALL_LEFT")	
		States.WALL_RIGHT:
			curr_State = States.WALL_RIGHT
			print("WALL_RIGHT")	
		States.FALLING:
			curr_State = States.FALLING
			print("FALLING")	

#======================================== 	Variables 	==================================
#Movement variables
const speed = 5.0
var target_velocity = Vector3.ZERO
const JUMP_VELOCITY = 7
#const LERP_VAL = .15
var sprint_modifier = 1
var double_jump = 0

# Gravity
#var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") #Get the gravity from the project settings to be synced with RigidBody nodes.
var gravityStrength = 9.8
var GravityDirection = Vector3.DOWN #Base direction


#======================================== 	Collision Functions 	==================================
#slug touches the wall
func _on_wall_detector_body_entered(body):
	if body.is_in_group("Walls"):
		change_State(States.WALL_FORWARD)

#slug detaches from the wall 
func _on_wall_detector_body_exited(body):
	if body.is_in_group("Walls"):
		if is_on_floor() && curr_State != States.FLOOR:
			change_State(States.FLOOR)
		elif is_on_ceiling():
			change_State(States.CEILING)
		else:
			change_State(States.FALLING)


#======================================== 	Initialize 	==================================
func _ready():
	pass

#======================================== 	Process 	==================================
func _physics_process(delta):

	#base direction
	var direction = Vector3.ZERO
	
	# Detect if slug has landed
	if is_on_floor():
		if curr_State != States.FLOOR:
			change_State(States.FLOOR)

	# Add the gravity/falling
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (gravityStrength * delta)
		if (curr_State != States.FALLING):
			change_State(States.FALLING)
		
	#Double jump
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			target_velocity.y = JUMP_VELOCITY
			double_jump = 1
		elif !is_on_floor() && double_jump != 0:
			target_velocity.y += JUMP_VELOCITY
			double_jump = 0
	
	#Sprint Input / calculations
	sprint_modifier = 2 if Input.is_action_pressed("sprint") else 1
	
	#Calculating movemnt
	#Basic movement -> Needs change
	#TO-DO: apply states and actions so that the direction of the movement changes as the slug lands on different surfaces
	if Input.is_action_pressed("move_right"):
		direction.x -= 1
	if Input.is_action_pressed("move_left"):
		direction.x += 1
	if Input.is_action_pressed("move_forward"):
		direction.z -= 1
	if Input.is_action_pressed("move_back"):
		direction.z += 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()

	# Animation Tree
	if direction.x == 0 && direction.z == 0: 
		animated_sprite_3d.play("idle")
	else:
		animated_sprite_3d.play("walk")
		
	# Flip Sprite
	if direction.x > 0 || direction.z > 0:
		animated_sprite_3d.flip_h = true
	elif direction.x < 0 || direction.z < 0:
		animated_sprite_3d.flip_h = false

	# Ground Velocity
	target_velocity.x = direction.x * speed * sprint_modifier
	target_velocity.z = direction.z * speed * sprint_modifier
	
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
