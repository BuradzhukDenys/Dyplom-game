@tool
extends ItemData
class_name PassiveItem

enum StatType
{
	FLAT,
	PERCENT
}

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

@export_group("Damage", "damage_")
@export var damage_type: StatType = StatType.FLAT:
	set(value):
		damage_type = value
		notify_property_list_changed()
@export var damage_bonus: float = 0.0
@export_range(-1, 1, 0.05) var damage_percent_bonus: float = 0.0

@export_group("Speed", "speed_")
@export var speed_type: StatType = StatType.FLAT:
	set(value):
		speed_type = value
		notify_property_list_changed()
@export var speed_bonus: float = 0.0
@export_range(-1, 1, 0.05) var speed_percent_bonus: float = 0.0

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
	if property.name.begins_with("damage_"):
		var damage_buff: bool = (buffs & 16) != 0
		
		if not damage_buff:
			property.usage &= ~PROPERTY_USAGE_EDITOR
			return
			
		if damage_type == StatType.FLAT and property.name == "damage_percent_bonus":
			property.usage &= ~PROPERTY_USAGE_EDITOR
		elif damage_type == StatType.PERCENT and property.name == "damage_bonus":
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name.begins_with("speed_"):
		var speed_buff: bool = (buffs & 32) != 0
		
		if not speed_buff:
			property.usage &= ~PROPERTY_USAGE_EDITOR
			return
			
		if speed_type == StatType.FLAT and property.name == "speed_percent_bonus":
			property.usage &= ~PROPERTY_USAGE_EDITOR
		elif speed_type == StatType.PERCENT and property.name == "speed_bonus":
			property.usage &= ~PROPERTY_USAGE_EDITOR

func get_tooltip_stats() -> String:
	var lines: PackedStringArray
	
	if (buffs & 1) != 0:
		var amplification_text: String = "+%.2f" if max_health_bonus >= 0 else "%.2f"
		lines.append("[color=green]Max health: " + amplification_text % max_health_bonus + "[/color]")
	if (buffs & 2) != 0:
		var amplification_text: String = "+%.2f" if health_restore_bonus >= 0 else "%.2f"
		lines.append("[color=lightgreen]Health restore: " + amplification_text % health_restore_bonus + "[/color]")
	if (buffs & 4) != 0:
		var amplification_text: String = "+%.2f" if max_mana_bonus >= 0 else "%.2f"
		lines.append("[color=purple]Max mana: " + amplification_text % max_mana_bonus + "[/color]")
	if (buffs & 8) != 0:
		var amplification_text: String = "+%.2f" if mana_restore_bonus >= 0 else "%.2f"
		lines.append("[color=magenta]Mana restore: " + amplification_text % mana_restore_bonus + "[/color]")
	if (buffs & 16) != 0:
		if damage_type == StatType.FLAT:
			var amp_text: String = "+%.2f" if damage_bonus >= 0 else "%.2f"
			lines.append("[color=red]Damage: " + amp_text % damage_bonus + "[/color]")
		else:
			var amp_text: String = "+%d%%" if damage_percent_bonus >= 0 else "%d%%"
			lines.append("[color=red]Damage: " + amp_text % (damage_percent_bonus * 100) + "[/color]")
	if (buffs & 32) != 0:
		if speed_type == StatType.FLAT:
			var amp_text: String = "+%.2f" if speed_bonus >= 0 else "%.2f"
			lines.append("[color=lightblue]Speed: " + amp_text % speed_bonus + "[/color]")
		else:
			var amp_text: String = "+%d%%" if speed_percent_bonus >= 0 else "%d%%"
			lines.append("[color=lightblue]Speed: " + amp_text % (speed_percent_bonus * 100) + "[/color]")
		
	return "\n".join(lines)
