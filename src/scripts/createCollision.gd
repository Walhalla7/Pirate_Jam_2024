extends MeshInstance3D
@export var collisionShape:CollisionShape3D

func _ready():
	#var newCollision = CollisionShape3D.new()
	#newCollision.set_shape(self.mesh.create_trimesh_shape()) 
	#get_parent().add_child(newCollision)
	
	collisionShape.set_shape(self.mesh.create_trimesh_shape()) 
