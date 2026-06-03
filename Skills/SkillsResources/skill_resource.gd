extends Resource
class_name SkillResource

enum SpawnType
{
	AT_PLAYER,
	AT_WORLD
}

@export var scene: PackedScene
@export var skill_icon: Texture
@export var mana_cost: int
@export var damage: float
@export var cooldown: float

@export var spawn_type: SpawnType
