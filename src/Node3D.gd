extends CharacterBody3D

#Camera managment
@onready var armature = $CollisionShape3D
@onready var spring_arm_pivot = $SpringArmPivot

#Movement variables
const speed = 5.0
var target_velocity = Vector3.ZERO
const JUMP_VELOCITY = 10
const LERP_VAL = .15
var sprint_modifier = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#======================================== 	Initialize 	==================================
func _ready():
	pass

#======================================== 	Process 	==================================
func _physics_process(delta):
	
	#base direction
	var direction = Vector3.ZERO
	
	# Add the gravit/falling
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (gravity * delta)
		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		target_velocity.y = JUMP_VELOCITY
	
	#Sprint Input / calculations
	sprint_modifier = 2 if Input.is_action_pressed("sprint") else 1
	
	#Calculating movemnt
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_forward"):
		direction.z += 1
	if Input.is_action_pressed("move_back"):
		direction.z -= 1
		
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		
	# Ground Velocity
	target_velocity.x = direction.x * speed * sprint_modifier
	target_velocity.z = direction.z * speed * sprint_modifier
	
	# Moving the Character
	velocity = target_velocity
	move_and_slide()
