extends Node

enum SkillType
{
	NONE,
	ICE_HAMMER,
	ICE_PROJECTILE
}

const SKILLS: Dictionary[SkillType, SkillResource] = {
	SkillType.ICE_HAMMER: preload("res://Skills/SkillsResources/ice_hammer.tres"),
	SkillType.ICE_PROJECTILE: preload("res://Skills/SkillsResources/ice_projectile.tres")
}
