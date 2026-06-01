extends VBoxContainer
class_name SkillsUI

@export var skill_slot_scene: PackedScene
@onready var skills_container: HBoxContainer = $HBoxContainer
var max_skills_count: int

func _ready() -> void:
	max_skills_count = PlayerData.skills_slots_count
	
	for i in range(1, max_skills_count + 1):
		var skill_slot = skill_slot_scene.instantiate()
		skills_container.add_child(skill_slot)

func setup(skill_comp: SkillComponent) -> void:
	for child: SkillSlot in skills_container.get_children():
		var current_slot_number: int = child.get_index() + 1
		child.setup(skill_comp, current_slot_number)
