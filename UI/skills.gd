extends VBoxContainer

@export var skill_slot_scene: PackedScene
@onready var skills_container: HBoxContainer = $HBoxContainer
var max_skills_count: int = GameData.skills_slots_count

func _ready() -> void:
	for i in max_skills_count:
		var skill_slot = skill_slot_scene.instantiate()
		skill_slot.set_slot_position(i + 1)
		skills_container.add_child(skill_slot)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_P and event.is_pressed():
			for child in $HBoxContainer.get_children():
				if child.is_free():
					child.setup_slot(SkillsManager.ICE_HAMMER)
					break
