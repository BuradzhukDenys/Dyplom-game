extends Node

signal healing_potion_drank
signal mana_potion_drank
signal player_mana_changed(new_value: float)
signal player_health_changed(new_value: float)
signal experience_changed(new_value: int)
signal gold_changed(new_value: int)
signal skill_casted(skill_resource: SkillResource)
signal no_mana
