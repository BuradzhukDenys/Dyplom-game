extends Node
class_name SkillComponent

@export var hp_mana_component: PlayerHPManaComponent

signal skill_casted(casted_slot: int, cooldown_time: float)
signal skill_cooldown_finished(skill_slot: int)

@export var skills: Dictionary[int, SkillsManager.SkillType] = {}
var cooldown: Dictionary = {}

func _ready() -> void:
	for i in range(1, PlayerData.skills_slots_count + 1):
		cooldown[i] = 0.0
		
		if not skills.has(i):
			skills[i] = SkillsManager.SkillType.NONE

func _process(delta: float) -> void:
	for slot in cooldown.keys():
		if cooldown[slot] > 0.0:
			cooldown[slot] -= delta
			
			if cooldown[slot] <= 0.0:
				cooldown[slot] = 0.0
				skill_cooldown_finished.emit(slot)

func setup(slot: int, skill_type: SkillsManager.SkillType) -> void:
	if not skills.has(slot):
		skills[slot] = skill_type

func try_cast_skill_at_slot(slot: int, direction: Vector2) -> void:
	if not skills.has(slot) or skills[slot] == SkillsManager.SkillType.NONE: return
	if cooldown.has(slot) and cooldown[slot] > 0.0: return
	
	var skill_id: SkillsManager.SkillType = skills[slot]
	var skill_data: SkillResource = SkillsManager.SKILLS[skill_id]
	
	if hp_mana_component.mana < skill_data.mana_cost:
		hp_mana_component.no_mana.emit()
		AudioManager.play_error()
		return
		
	hp_mana_component.spend_mana(skill_data.mana_cost)
	
	cooldown[slot] = skill_data.cooldown
	skill_casted.emit(slot, skill_data.cooldown)
	
	var skill: Skill = skill_data.scene.instantiate()
	skill.setup(direction, skill_data.damage)
	if skill is SkillProjectile and skill_data is SkillProjectileResource:
		skill.setup_projectile(skill_data.fly_time, skill_data.fly_speed)
	get_tree().current_scene.add_child(skill)
	skill.global_position = owner.global_position
