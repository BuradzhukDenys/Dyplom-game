extends Node
class_name HPComponent

signal health_changed(new_value: float, type: HEALTH_CHANGED_TYPE)

enum HEALTH_CHANGED_TYPE
{
	TAKE_DAMAGE,
	HEAL,
	PASSIVE_HEAL
}

@export var base_health: float = 100
var health: float

func _ready() -> void:
	health = base_health
	
func take_damage(amount: float) -> void:
	health = clampf(health - amount, 0, base_health)
	health_changed.emit(health, HEALTH_CHANGED_TYPE.TAKE_DAMAGE)

func heal(amount: float) -> void:
	health = clampf(health + amount, 0, base_health)
	health_changed.emit(health, HEALTH_CHANGED_TYPE.HEAL)
