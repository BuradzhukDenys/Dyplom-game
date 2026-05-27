@tool
extends ItemData
class_name PassiveItem

@export_flags("MaxHealth", "HealthRestore", "MaxMana", "ManaRestore", "Damage", "Speed") var buffs: int:
	set(value):
		buffs = value
		notify_property_list_changed()

@export_group("MaxHealth")
@export var max_health_bonus: float = 0.0

@export_group("HealthRestore")
@export var health_restore_bonus: float = 0.0

@export_group("MaxMana")
@export var max_mana_bonus: float = 0.0

@export_group("ManaRestore")
@export var mana_restore_bonus: float = 0.0

@export_group("Damage")
@export var damage_bonus: float = 0.0

@export_group("Speed")
@export var speed_bonus: float = 0.0

func _validate_property(property: Dictionary) -> void:
	if property.name == "max_health_bonus":
		var max_health_buff: bool = (buffs & 1) != 0
		
		if not max_health_buff:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name == "health_restore_bonus":
		var health_restore_buff: bool = (buffs & 2) != 0
		
		if not health_restore_buff:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name == "max_mana_bonus":
		var max_mana_buff: bool = (buffs & 4) != 0
		
		if not max_mana_buff:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name == "mana_restore_bonus":
		var mana_restore_buff: bool = (buffs & 8) != 0
		
		if not mana_restore_buff:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name == "damage_bonus":
		var damage_buff: bool = (buffs & 16) != 0
		
		if not damage_buff:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name == "speed_bonus":
		var speed_buff: bool = (buffs & 32) != 0
		
		if not speed_buff:
			property.usage &= ~PROPERTY_USAGE_EDITOR
