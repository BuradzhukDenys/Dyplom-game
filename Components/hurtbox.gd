extends Area2D

@export var hp_component: HPComponent

func get_hp_component() -> HPComponent:
	if hp_component:
		return hp_component
		
	return null
