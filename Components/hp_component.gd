extends Node
class_name HPComponent

signal health_changed(new_value: float)

const BASE_MAX_HEALTH: float = 100.0
var health: float
var is_invincible: bool = false

func _ready() -> void:
	health = BASE_MAX_HEALTH
	
func take_damage(amount) -> void:
	if is_invincible:
		return
	
	health = clamp(health - amount, 0, BASE_MAX_HEALTH)
	health_changed.emit(health)
