extends Node3D

class_name WitchDetector

@export var player : CharacterBody3D
@export var lock_x = true
@export var lock_z = false

@onready var ray_cast_3d = $RayCast3D
@onready var timer = $Timer
@onready var hand = $CanvasLayer/Sprite2D
@onready var offscreen_point = $CanvasLayer/Offscreen
@onready var onscreen_point = $CanvasLayer/Onscreen
@onready var vin = $CanvasLayer/ColorRect

var t = 0.0
var visibilityLevel:float = 1.0
var player_caught = false
var return_hand = false

# TO USE: Set the player to collision mask 1 and anything they can hide behind on collision layer 6
# Connect assign player in the inspector

# Called when the node enters the scene tree for the first time.
func _ready():
	ray_cast_3d.global_position = player.global_position
	ray_cast_3d.global_position.z = 5
	visibilityLevel = 1 
	return_hand = false
	player_caught = false

func _is_visible():
	return ray_cast_3d.is_colliding() && ray_cast_3d.get_collider().is_in_group("Slug")

func set_vin():
	var math:float = 1.0 - (visibilityLevel/10.0)
	print("math: ", math)
	vin.material.set_shader_parameter("multiplier", math)

func _on_timer_timeout():
	if _is_visible():
		visibilityLevel += 1
		SignalBus.emit_signal("changeVisibility", visibilityLevel)
		if visibilityLevel >= 10:
			player_caught = true
			timer.stop()
	else:
		if visibilityLevel > 1:
			SignalBus.emit_signal("changeVisibility", visibilityLevel)
			visibilityLevel -= 1
	set_vin()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Follow the player left and right
	ray_cast_3d.global_position.x = player.global_position.x
	# Follow the player up and down
	ray_cast_3d.global_position.y = player.global_position.y
	
	#print(visibilityLevel)
	
	if player_caught:
		t += delta * 0.01
		if !return_hand:
			hand.position = hand.position.lerp(onscreen_point.position, t)
			if hand.position.distance_to(onscreen_point.position) < 0.5:
				return_hand = true
				player.hide()
		else:
			hand.position = hand.position.lerp(offscreen_point.position, t)
			if hand.position.distance_to(offscreen_point.position) < 0.1:
				SignalBus.emit_signal("game_over")
	
	

	
