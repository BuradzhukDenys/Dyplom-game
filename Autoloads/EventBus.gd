extends Node

signal healing_potion_cooldown_finished
signal mana_potion_cooldown_finished
signal healing_potion_drank
signal mana_potion_drank
signal player_mana_changed(new_value: float)
signal player_health_changed(new_value: float)
signal experience_changed(new_value: int)
signal gold_changed(new_value: int)
signal skill_casted(casted_slot: int, cooldown_time: float)
signal no_mana
signal weapon_changed(new_weapon: SwordData)
