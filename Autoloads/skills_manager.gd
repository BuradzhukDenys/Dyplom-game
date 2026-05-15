extends Node

const ICE_HAMMER: SkillResource = preload("res://Skills/SkillsResources/ice_hammer.tres")

var skills: Dictionary[int, SkillResource] = {
	1: null,
	2: null,
	3: null,
	4: null,
	5: null
}

var next_cast_times: Dictionary = {1: 0.0, 2: 0.0, 3: 0.0}

func is_skill_ready(pos: int) -> bool:
	if skills[pos] == null: return false
	
	return Time.get_ticks_msec() >= next_cast_times[pos]

func put_skill_on_cooldown(pos: int) -> void:
	var skill: SkillResource = skills[pos]
	if skill:
		next_cast_times[pos] = Time.get_ticks_msec() + (skill.cooldown * 1000.0)
