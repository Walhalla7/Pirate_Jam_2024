extends StateMachine

func _state_logic(delta):
	add_state("FLOOR")
	add_state("WALL_FORWARD")
	add_state("WALL_BACK")
	add_state("WALL_LEFT")
	add_state("WALL_RIGHT")
	add_state("FALLING")
	add_state("JUMPING")
	call_deferred("set_state", states.FLOOR)

func _get_transition(delta):
	return null

func _enter_state(new_state, old_state):
	pass

func _exit_state(old_state, new_state):
	pass
