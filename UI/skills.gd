extends VBoxContainer

@onready var skills_resources: Dictionary = {
	SkillResource.SkillType.ICE_HUMMER: preload("res://skill1.tres")
}

@onready var skills: Dictionary = {
	"skill1": $HBoxContainer/Skill1,
	"skill2": $HBoxContainer/Skill2,
	"skill3": $HBoxContainer/Skill3,
	"skill4": $HBoxContainer/Skill4,
	"skill5": $HBoxContainer/Skill5
}

@onready var skills_cooldown: Dictionary = {
	"skill1": $HBoxContainer/Skill1/PanelContainer/TextureProgressBar,
	"skill2": $HBoxContainer/Skill2/PanelContainer/TextureProgressBar,
	"skill3": $HBoxContainer/Skill3/PanelContainer/TextureProgressBar,
	"skill4": $HBoxContainer/Skill4/PanelContainer/TextureProgressBar,
	"skill5": $HBoxContainer/Skill5/PanelContainer/TextureProgressBar
}

@onready var skills_cooldown_label: Dictionary = {
	"skill1": $HBoxContainer/Skill1/PanelContainer/SecondsCooldown,
	"skill2": $HBoxContainer/Skill2/PanelContainer/SecondsCooldown,
	"skill3": $HBoxContainer/Skill3/PanelContainer/SecondsCooldown,
	"skill4": $HBoxContainer/Skill4/PanelContainer/SecondsCooldown,
	"skill5": $HBoxContainer/Skill5/PanelContainer/SecondsCooldown
}

var skill1_tween: Tween
var skill2_tween: Tween
var skill3_tween: Tween
var skill4_tween: Tween
var skill5_tween: Tween

var skills_tween: Dictionary = {
	"skill1": skill1_tween,
	"skill2": skill2_tween,
	"skill3": skill3_tween,
	"skill4": skill4_tween,
	"skill5": skill5_tween
}

@onready var skills_timers: Dictionary = {
	"skill1": $HBoxContainer/Skill1/CooldownTimer,
	"skill2": $HBoxContainer/Skill2/CooldownTimer,
	"skill3": $HBoxContainer/Skill3/CooldownTimer,
	"skill4": $HBoxContainer/Skill4/CooldownTimer,
	"skill5": $HBoxContainer/Skill5/CooldownTimer
}

func _ready() -> void:
	EventBus.skill_casted.connect(_on_skill_casted)
	skills_resources[SkillResource.SkillType.ICE_HUMMER].skill_position = 1
	
	for skill in skills_cooldown:
		skills_cooldown[skill].value = 0
		
	for skill in skills_cooldown_label:
		skills_cooldown_label[skill].text = ""
		skills_cooldown_label[skill].visible = false
		
	for skill in skills_timers:
		skills_timers[skill].timeout.connect(func(): 
			skills_cooldown_label[skill].visible = false
			if skill.contains("1"):
				PlayerData.skill1_cooldown = false
			elif skill.contains("2"):
				PlayerData.skill2_cooldown = false
			elif skill.contains("3"):
				PlayerData.skill3_cooldown = false
			elif skill.contains("4"):
				PlayerData.skill4_cooldown = false
			elif skill.contains("5"):
				PlayerData.skill5_cooldown = false
			)

func _process(_delta: float) -> void:
	for skill in skills_timers:
		if skills_timers[skill].time_left > 0:
			skills_cooldown_label[skill].text = str(int(skills_timers[skill].time_left + 1))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_0 and event.is_pressed():
			start_skill_cooldown(skills_resources[SkillResource.SkillType.ICE_HUMMER], skills_tween["skill1"], skills_timers["skill1"], skills_cooldown["skill1"], skills_cooldown_label["skill1"])

func _on_skill_casted(skill_resource: SkillResource) -> void:
	var i: int = 1
	for skill in skills_resources:
		if skill_resource.skill_type == skill:
			var skill_position: String = "skill" + str(i)
			skills_cooldown_label[skill_position].text = str(skill_resource.cooldown)
			skills_tween[skill_position] = start_skill_cooldown(skill_resource, skills_tween[skill_position], skills_timers[skill_position], skills_cooldown[skill_position], skills_cooldown_label[skill_position])
		i += 1
	
func start_skill_cooldown(skill_resource: SkillResource, skill_tween: Tween, skill_timer: Timer, skill_cooldown: TextureProgressBar, skill_cooldown_label: Label) -> Tween:
	skill_timer.start(skill_resource.cooldown)
	
	skill_cooldown.value = skill_cooldown.max_value
	skill_cooldown_label.text = str(skill_resource.cooldown)
	skill_cooldown_label.visible = true
	
	if skill_tween and skill_tween.is_valid():
		skill_tween.kill()
				
	var new_tween: Tween
	new_tween = create_tween()
	new_tween.tween_property(skill_cooldown, "value", skill_cooldown.min_value, skill_resource.cooldown)
			
	return new_tween
