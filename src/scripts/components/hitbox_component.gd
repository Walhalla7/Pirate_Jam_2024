extends Area3D

class_name Hitbox

@export var health_component: HealthComponent

func _ready():
	# We probably should set the collision layers here but they should be on 4 and mask for 3
	pass


func deal_damage(damage_value: Damage_Value_Component):
	if health_component:
		health_component.damage(damage_value)

# when an object enters the player if it has a damage component it deals damage to the health component
func _on_body_entered(body):
	print(str(body))
	if body.damage_value_component:
		deal_damage(body.damage_value_component)

	#Here is where knockback methods can be called
