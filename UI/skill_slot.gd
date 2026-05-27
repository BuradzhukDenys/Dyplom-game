extends PanelContainer
class_name SkillSlot

@onready var skill_icon: TextureRect = $PanelContainer/TextureRect
@onready var skill_cooldown: TextureProgressBar = $PanelContainer/TextureProgressBar
@onready var skill_cooldown_label: Label = $PanelContainer/SecondsCooldown
@onready var skill_cooldown_timer: Timer = $CooldownTimer
@onready var skill_key_label: Label = $PanelContainer/MarginContainer/Label

var current_tween: Tween

@export var skill_data: SkillResource
@export_range(1, 5) var slot_position: int
var has_skill: bool = false

func _ready() -> void:
	skill_cooldown.value = 0
	skill_cooldown_label.text = ""
	skill_cooldown_label.visible = false
	skill_cooldown_timer.stop()
	skill_icon.texture = null
	skill_key_label.text = str(slot_position)
	
	if skill_data:
		setup_slot(skill_data)

func _process(_delta: float) -> void:
	if skill_cooldown_label.visible:
		skill_cooldown_label.text = str(int(skill_cooldown_timer.time_left) + 1)
		
func setup(skill_comp: SkillComponent, new_slot_position: int) -> void:
	skill_comp.skill_casted.connect(_on_skill_casted)
	skill_comp.skill_cooldown_finished.connect(_on_skill_cooldown_finished)
	
	slot_position = new_slot_position
	skill_key_label.text = str(slot_position)
	
	if skill_comp.skills.has(slot_position) and skill_comp.skills[slot_position] != SkillsManager.SkillType.NONE:
		setup_slot(SkillsManager.SKILLS[skill_comp.skills[slot_position]])

func is_free() -> bool:
	return not has_skill

func setup_slot(skill_resource: SkillResource) -> void:
	if skill_data != skill_resource:
		skill_data = skill_resource
		
	has_skill = true
	
	skill_icon.texture = skill_data.skill_icon
	skill_cooldown_timer.wait_time = skill_data.cooldown
	
func _on_skill_casted(casted_slot: int, cooldown_time: float) -> void:
	if casted_slot != slot_position:
		return
	
	skill_cooldown.value = skill_cooldown.max_value
	skill_cooldown_label.visible = true
	
	if current_tween and current_tween.is_valid():
		current_tween.kill()
		
	skill_cooldown_timer.start(cooldown_time)
	current_tween = create_tween()
	current_tween.tween_property(skill_cooldown, "value", skill_cooldown.min_value, cooldown_time)

func _on_skill_cooldown_finished(slot: int) -> void:
	if slot == slot_position:
		skill_cooldown_label.visible = false
