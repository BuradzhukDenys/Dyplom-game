extends Resource
class_name SkillResource

enum SkillType
{
	ICE_HUMMER
}

@export var scene: PackedScene
@export var mana_cost: int
@export var damage: float
@export var cooldown: int
@export var cast_range: float
@export var area: float
@export var skill_type: SkillType
var skill_position: int
