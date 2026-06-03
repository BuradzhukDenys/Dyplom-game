@tool
extends ItemData
class_name SwordData

@export var damage: float
@export var attack_interval: float
#@export var attack_range: int
		
@export_group("Additional Effects")
@export_flags("Fire", "Ice", "Lightning", "Vampiric") var additional_effects: int = 0:
	set(value):
		additional_effects = value
		notify_property_list_changed()
		
@export_subgroup("Fire effect values")
@export var fire_duration: float
@export var fire_damage: float

@export_subgroup("Ice effect values")
@export var ice_duration: float
@export_range(0.0, 1.0, 0.05) var ice_slowness: float

@export_subgroup("Lightning effect values")
@export var lightning_damage: float
@export var lightning_chains: int

@export_subgroup("Vampiric effect values")
@export var lifesteal: float

func get_tooltip_stats() -> String:
	var lines = PackedStringArray()
	
	lines.append("[color=red]Damage: %.1f[/color]" % damage)
	lines.append("[color=green]Attack interval: %.3fs[/color]" % attack_interval)
	#lines.append("[color=light_blue]Attack range: %d[/color]" % attack_range)
	
	if additional_effects != 0:
		lines.append("\n[color=purple]Additional effects:[/color]")
		
		if (additional_effects & 1) != 0:
			lines.append("[color=orange]Fire:\n     - Duration: %ds.\n     - Damage: %ddps[/color]" % [fire_duration, fire_damage])
		if (additional_effects & 2) != 0:
			lines.append("[color=skyblue]Ice:\n     - Duration: %ds.\n     - Slowness: %d%%[/color]" % [ice_duration, ice_slowness * 100])
		if (additional_effects & 4) != 0:
			lines.append("[color=yellow]Lightning:\n     - Damage: %.1f\n     - Max chains: %d[/color]" % [lightning_damage, lightning_chains])
		if (additional_effects & 8) != 0:
			lines.append("[color=#8A0303]Vampiric:\n     - LifeSteal: %.1f[/color]" % lifesteal)
			
	return "\n".join(lines)
			

func _validate_property(property: Dictionary) -> void:
	if property.name == "fire_duration" or property.name == "fire_damage":
		var has_fire = (additional_effects & 1) != 0
		
		if not has_fire:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name == "ice_duration" or property.name == "ice_slowness":
		var has_ice = (additional_effects & 2) != 0
		
		if not has_ice:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name == "lightning_damage" or property.name == "lightning_chains":
		var has_lightning = (additional_effects & 4) != 0
		
		if not has_lightning:
			property.usage &= ~PROPERTY_USAGE_EDITOR
	if property.name == "lifesteal":
		var has_vampiric = (additional_effects & 8) != 0
		
		if not has_vampiric:
			property.usage &= ~PROPERTY_USAGE_EDITOR
