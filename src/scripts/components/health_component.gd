extends Node3D

class_name HealthComponent

signal hurt
signal death

# Settable MAX Health for the object, can be adjusted in inspector
@export var MAX_HEALTH := 3

# variable for current health
var health : float

# Called when the node enters the scene tree for the first time.
func _ready():
	health = MAX_HEALTH

func damage(damage: Damage_Value_Component):
	health -= damage.damage_value

	if health <= 0:
		death.emit()
	else:
		print(str(get_parent().name) + "'s health is " + str(health))
		hurt.emit()
