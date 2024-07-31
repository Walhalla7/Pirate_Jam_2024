extends Node

var startStrength

func _ready():
	SignalBus.changeVisibility.connect(_change_intensity)
	startStrength = get_parent().light_energy
	

func _change_intensity(strength):
	#get_parent().light_energy = startStrength + startStrength * (strength/2)
	if get_parent().light_energy >= startStrength * 0.1:
		get_parent().light_energy = startStrength - startStrength* (strength/10)

