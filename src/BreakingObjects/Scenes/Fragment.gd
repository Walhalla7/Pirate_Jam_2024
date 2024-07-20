extends RigidBody3D
class_name Fragment

@export var lifetime:float = 5
var elapsed_time:float = 0

#called when the node enters the scene tree for the first time
func _ready():
	pass
	
#called every frame
func _process(delta):
	elapsed_time += delta
	if elapsed_time > lifetime:
		queue_free()
		

func init_from_mesh(source:MeshInstance3D):
	global_transform = source.global_transform
	
	var mesh_inst:MeshInstance3D = source.duplicate()
	mesh_inst.transform = Transform3D.IDENTITY
	add_child(mesh_inst)
	
	$CollisionShape3D.shape = source.mesh.create_convex_shape()
