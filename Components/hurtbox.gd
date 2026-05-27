extends Area2D
class_name Hurtbox

@export var hp_component: HPComponent

func take_damage(amount: float) -> void:
	if hp_component:
		hp_component.take_damage(amount)
