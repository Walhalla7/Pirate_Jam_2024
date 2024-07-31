extends Node3D


@onready var bubble_scene = preload("res://scenes/bubble.tscn")
@onready var origin_position = $SpawnPosition.global_position

var bubbles_array = Array([],TYPE_OBJECT, &"", null)
var time :float
var deletion_queue = Array([],TYPE_OBJECT, &"", null)



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	time += delta
	move_bubbles()
	delete_bubbles()

#sinusoidal bubble movement in x,z plane + contstant y, queues bubble instances for deletion when they reach a certain height
func move_bubbles():
	
	for bubble in bubbles_array:
		bubble.global_position.x += sin(time*2)/100  #sin(time*frequency+phase)/amplitude
		bubble.global_position.z += sin(time*2)/100
		bubble.global_position.y += .02
		if bubble.global_position.y >= 37 + randf():
			bubble.play("pop")
			#print("bubble pop animation started")
			bubbles_array.erase(bubble)
			deletion_queue.append(bubble)

#creates a bubble scene instance at timeout within a random x,z range
func _on_spawn_timer_timeout():
	
	var new_bubble = bubble_scene.instantiate()
	add_child(new_bubble)
	#print("new bubble made")
	new_bubble.global_position = Vector3(origin_position.x + randf_range(-3,3), origin_position.y, origin_position.z + randf_range(-3,3))
	bubbles_array.append(new_bubble)

#goes through the deletion queue and deletes instances once they reach last animation frame
func delete_bubbles():
	for bubble in deletion_queue:
		if bubble.get_frame() == 5:
			deletion_queue.erase(bubble)
			bubble.free()
			#print("bubble deleted")
