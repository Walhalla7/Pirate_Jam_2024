extends Node3D

class_name HealthComponent 

#======================================== 	Variables 	==================================
@export var MAX_HEALTH := 3

@onready var skull_icon = $"../SkullSprite"

var health : float

#======================================== 	Signals 	==================================
signal hurt
signal death

#======================================== 	Initialize 	==================================
func _ready():
	health = MAX_HEALTH
	skull_icon.visible = false
	
#======================================== 	Functions for Health 	==================================	
func decrement_health(damage: DamageComponent):
	health -= damage.damage_value
	
	if health <= 0:
		death.emit()
		SignalBus.emit_signal("game_over")
	if health == 1: 
		skull_icon.visible = true
	else:
		print(str(get_parent().name) + "'s health is " + str(health))
		hurt.emit()
