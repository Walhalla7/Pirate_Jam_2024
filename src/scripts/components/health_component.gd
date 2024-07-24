extends Node3D

class_name HealthComponent 

#======================================== 	Variables 	==================================
@export var MAX_HEALTH := 3

var health : float

#======================================== 	Signals 	==================================
signal hurt
signal death

#======================================== 	Initialize 	==================================
func _ready():
	health = MAX_HEALTH

#======================================== 	Functions for Health 	==================================	
func decrement_health(damage: DamageComponent):
	health -= damage.damage_value
	
	if health <= 0:
		death.emit()
	else:
		print(str(get_parent().name) + "'s health is " + str(health))
		hurt.emit()
