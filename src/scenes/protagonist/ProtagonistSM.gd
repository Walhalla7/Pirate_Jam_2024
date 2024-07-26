extends StateMachine

#function to handle jump input
func _input(event):
	if [states.IDLE, states.WALKING].has(state):
		if event.is_action("jump") && parent.is_Grounded:
			parent.velocity.y = parent.JUMP_VELOCITY
	elif [states.WALL_BACK, states.WALL_LEFT, states.WALL_RIGHT].has(state):
		if event.is_action("jump"):
			parent.wall_jump()

func _ready():
	add_state("IDLE")
	add_state("WALKING")
	add_state("WALL_BACK")
	add_state("WALL_LEFT")
	add_state("WALL_RIGHT")
	add_state("FALLING")
	add_state("JUMPING")
	call_deferred("set_state", states.IDLE)

func _state_logic(delta):
	match state:
		states.WALL_LEFT:
			parent._handle_move_Left_input()
		states.WALL_RIGHT:
			parent._handle_move_Right_input()
		states.WALL_BACK:
			parent._handle_move_Back_input()
		_:
			parent._handle_move_input()
	parent._apply_movement()
	parent._apply_gravity(delta)
	print(states.keys()[state])

#conditions for transitioning between states
func _get_transition(delta):
	match state:
		#Leaving idle state
		states.IDLE:
			if !parent.is_Grounded:
				if parent.velocity.y > 0:
					return states.JUMPING
				elif parent.velocity.y < 0:
					return states.FALLING
			elif parent.velocity.x != 0 || parent.velocity.z != 0:
				return states.WALKING
				
		#Leaving Walking state
		states.WALKING:
			if parent.rightDetector.is_colliding() && parent.velocity.x < 0:
				return states.WALL_RIGHT
			elif parent.leftDetector.is_colliding() && parent.velocity.x > 0:
				return states.WALL_LEFT
			elif parent.backDetector.is_colliding() && parent.velocity.z > 0:
				return states.WALL_BACK
			elif !parent.is_Grounded:
				if parent.velocity.y > 0:
					return states.JUMPING
				elif parent.velocity.y < 0:
					return states.FALLING
			elif parent.velocity.x == 0 && parent.velocity.z == 0:
				return states.IDLE
				
		#Leaving Wall left state
		states.WALL_LEFT:
			if !parent.leftDetector.is_colliding() && !parent.is_Grounded && !parent.backDetector.is_colliding():
				if parent.velocity.y > 0:
					return states.JUMPING
				elif parent.velocity.y < 0:
					return states.FALLING
			elif parent.backDetector.is_colliding() && parent.velocity.x < 0:
				return states.WALL_BACK
			elif parent.is_Grounded && parent.velocity.x < 0:
				return states.IDLE
				
		#Leaving Right state
		states.WALL_RIGHT:
			if !parent.rightDetector.is_colliding() && !parent.is_Grounded && !parent.backDetector.is_colliding():
				if parent.velocity.y > 0:
					return states.JUMPING
				elif parent.velocity.y < 0:
					return states.FALLING
			elif parent.backDetector.is_colliding() && parent.velocity.x > 0:
				return states.WALL_BACK
			elif parent.is_Grounded && parent.velocity.x > 0:
				return states.IDLE
				
		#Leaving back state
		states.WALL_BACK:
			if !parent.backDetector.is_colliding() && !parent.is_Grounded && !parent.rightDetector.is_colliding() && !parent.leftDetector.is_colliding():
				if parent.velocity.y > 0:
					return states.JUMPING
				elif parent.velocity.y < 0:
					return states.FALLING
			elif parent.rightDetector.is_colliding() && parent.velocity.x < 0:
				return states.WALL_RIGHT
			elif parent.leftDetector.is_colliding() && parent.velocity.x > 0:
				return states.WALL_LEFT
			elif parent.is_Grounded && parent.velocity.z < 0:
				return states.IDLE
				
		#Leaving Jump state
		states.JUMPING:
			if parent.rightDetector.is_colliding() && parent.velocity.x < 0:
				return states.WALL_RIGHT
			elif parent.leftDetector.is_colliding() && parent.velocity.x > 0:
				return states.WALL_LEFT
			elif parent.backDetector.is_colliding() && parent.velocity.z > 0:
				return states.WALL_BACK
			elif parent.is_Grounded:
				return states.IDLE
			elif parent.velocity.y <= 0:
				return states.FALLING
				
		#Leaving fall state
		states.FALLING:
			if parent.rightDetector.is_colliding() && parent.velocity.x < 0:
				return states.WALL_RIGHT
			elif parent.leftDetector.is_colliding() && parent.velocity.x > 0:
				return states.WALL_LEFT
			elif parent.backDetector.is_colliding() && parent.velocity.z > 0:
				return states.WALL_BACK
			elif parent.is_Grounded:
				return states.IDLE
			elif parent.velocity.y > 0:
				return states.JUMPING
				
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
