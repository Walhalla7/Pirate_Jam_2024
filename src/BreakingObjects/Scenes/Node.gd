extends Node

#Behavior related to explosion
@export_flags_3d_physics var fragment_collision_layer:int = 1
@export_flags_3d_physics var fragment_collision_mask:int = 1
@export var explosion_speed:float = 4
@export var min_frag_lifetime:float = 1.2
@export var max_frag_lifetime:float = 1.8

#private variables 
var parent 
@onready var endTimer = $DeletionTimer

#variables related with mesh
@export var Before: Node3D
@export var After: Node3D
@export var ExplosionSource: Marker3D

#make sure only before node is visible 
func  _ready():
	parent = get_parent()
	for child in parent.get_children():
		if child.get_class() == "Node3D" ||  child.get_class() == "MeshInstance3D":
			child.visible = false
	Before.visible = true
	endTimer.wait_time = max_frag_lifetime


func  _process(delta):
	if Input.is_action_just_pressed("ExplosionTest"):
		explode()

func explode():
	Before.queue_free()
	endTimer.start()
	for child in After.get_children():
		if child is MeshInstance3D:
			var frag:Fragment = preload("res://BreakingObjects/Scenes/Fragment.tscn").instantiate()
			frag.init_from_mesh(child)
			frag.collision_layer = fragment_collision_layer
			frag.collision_mask = fragment_collision_mask
			parent.add_child(frag)
			
			var vel:Vector3 = (frag.global_transform.origin - ExplosionSource.global_transform.origin * randf()) * explosion_speed
			frag.linear_velocity = vel
			
			frag.lifetime = randf_range(min_frag_lifetime, max_frag_lifetime)


func _on_deletion_timer_timeout():
	parent.queue_free()
