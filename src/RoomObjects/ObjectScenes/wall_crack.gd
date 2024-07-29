extends Sprite3D

@export var endLocation: Marker3D
@export var PlayerCamera: Node3D
var finalPosition: Vector3

func _ready():
	if endLocation:
		finalPosition = endLocation.global_transform.origin

func _on_area_3d_body_entered(body):
	if body.is_in_group("Slug") and endLocation:
		# Teleport the body
		if PlayerCamera:
			PlayerCamera.lock_x = true
			PlayerCamera.lock_z = false
		
		body.global_transform.origin = finalPosition
