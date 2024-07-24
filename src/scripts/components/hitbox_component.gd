extends Area3D

class_name HitboxComponent

@export var health_component : HealthComponent

# Call to the healthcomponent to decrement health value by damage value
func decrement_health(damage: DamageComponent):
	if health_component:
		health_component.decrement_health(damage)

# When the collision for an object to do damage enters the obj to be damaged
func _on_body_entered(body):
	if body.damage_component:
		decrement_health(body.damage_component)

