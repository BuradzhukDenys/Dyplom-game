extends Node

const ICE_HAMMER: SkillResource = preload("res://Skills/SkillsResources/ice_hammer.tres")

var skills: Dictionary = {
	1: null,
	2: null,
	3: null,
	4: null,
	5: null
}

func skill_in_cooldown_at_pos(pos: int) -> bool:
	if skills[pos] != null:
		return skills[pos].in_cooldown
	return false

func get_skill_data_at_pos(pos: int) -> SkillResource:
	return skills[pos]

func set_skill_cooldown_at_pos(pos: int, value: bool) -> void:
	if skills[pos] != null:
		skills[pos].in_cooldown = value
