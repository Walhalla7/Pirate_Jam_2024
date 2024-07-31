extends Node



@onready var slugjar = $Slugjar
@onready var slugjar_position = slugjar.position
var shake_vector :Vector3
@onready var camera = $IntroCamera
@onready var camera_position = $IntroCamera.global_position
@onready var camera_position2 = $IntroCamera_Position2
@onready var camera_position3 = $IntroCamera_Position3
@onready var slugjar_tracker = $SlugjarTracker
var camera_transition_speed = 5
var transition_speed :float
var position_difference :float


@onready var current_step= 1


# Called when the node enters the scene tree for the first time.
func _ready():
	slugjar_tracker.global_position = camera_position2.global_position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	transition_speed += delta/100
	#track jar pos for interpolation
	slugjar_position = slugjar.position
	slugjar_tracker.global_position.x = slugjar.global_position.x
	slugjar_tracker.global_position.y = slugjar.global_position.y
	
	match current_step:
		1:
			transition_speed += delta/100
			#interpoate camera 1 and 2
			camera.transform = camera.transform.interpolate_with(camera_position2.transform, transition_speed)
			camera_position = camera.global_position
			#print(camera_position)
			
			position_difference = camera.global_position.x - camera_position2.global_position.x
			if abs(position_difference) < 0.01:
				current_step = 2
				$Timer.stop()
				print("step 1 complete")
				#when camera 1 pos = camera 2 pos, step = 2
		2:
			#camera look at jar
			camera.look_at(slugjar.global_position)
			slugjar_impulse(5)
			current_step = 3
		3:
			
			transition_speed += delta/10
			#knock the jar over, interpolate camera to falling jar
			camera.transform = camera.transform.interpolate_with(slugjar_tracker.transform, transition_speed)
			camera.look_at(slugjar.global_position)
			if slugjar_position.y < 10:
				current_step = 4

		4:
			#interpolate to cam 3, initialize protag sprite @ jar position
			camera.transform = camera.transform.interpolate_with(slugjar_tracker.transform, transition_speed)
			#protag.idle no hat
			#hat sprite. position y --
			#when hat.y == above slug, protag.anim = idle_look_up
			#when hat.y == on slug, protag.anim = idle with hat, remove hat node
			#step = 4
			pass
		5:
			#protag sprite. x ++
			#when inside wall, signal main, free intro scene
			pass

func slugjar_impulse(strenght):
	print("applied impulse")
	slugjar.apply_impulse(Vector3(strenght,0,0),Vector3(1,0,0))

func _on_timer_timeout():
	print("timer")
	if current_step == 1:
		slugjar_impulse(1)
