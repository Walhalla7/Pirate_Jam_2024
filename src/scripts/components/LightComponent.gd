extends Node

var startStrength

func _ready():
	SignalBus.changeVisibility.connect(_change_intensity)
	SignalBus.changeLightColor.connect(_turn_red)
	startStrength = get_parent().light_energy
	

func _change_intensity(strength):
	#get_parent().light_energy = startStrength + startStrength * (strength/2)
	if get_parent().light_energy >= startStrength * 0.2:
		get_parent().light_energy = startStrength / (strength)

func _turn_red():
	get_parent().light_color  = Color(144,166,0)
