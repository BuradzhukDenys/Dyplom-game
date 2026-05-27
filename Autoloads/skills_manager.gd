extends Node

enum SkillType
{
	NONE,
	ICE_HAMMER
}

const SKILLS: Dictionary[SkillType, SkillResource] = {
	SkillType.ICE_HAMMER: preload("res://Skills/SkillsResources/ice_hammer.tres")
}
