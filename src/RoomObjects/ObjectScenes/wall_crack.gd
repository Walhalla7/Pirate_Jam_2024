extends Sprite3D

@export var endLocation: Marker3D
@export var Camera: Camera3D
var finalPosition: Vector3

func _ready():
	if endLocation:
		finalPosition = endLocation.global_transform.origin

func _on_area_3d_body_entered(body):
	if body.is_in_group("Slug") and endLocation:
		# Teleport the body
		if Camera:
			# Ensure Camera is properly managed; this line might not be needed.
			Camera.current = !Camera.current
		body.global_transform.origin = finalPosition
