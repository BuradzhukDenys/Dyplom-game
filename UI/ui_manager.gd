extends CanvasLayer

@onready var hp_mana_bars: HPManaBars = $MarginContainer/LeftSide/Info/HPMana
@onready var potions: PotionsUI = $MarginContainer/MarginContainer/Potions
@onready var skills: SkillsUI = $MarginContainer/PanelContainer/Skills
@onready var wave_label: Label = $MarginContainer/TopWaveCounter/VBoxContainer/WaveCount
@onready var level_label: Label = $MarginContainer/TopWaveCounter/VBoxContainer/LevelName

func _ready() -> void:
	var level_resource: LevelResource = load("res://Levels/Resources/level1.tres")
	level_label.text = level_resource.level_name
	EventBus.wave_changed.connect(_on_wave_changed)
	
	var character: Character = get_tree().get_first_node_in_group("character")
	
	if character:
		var hp_mana_comp: PlayerHPManaComponent = character.hp_mana_component
		var potions_comp: PotionsComponent = character.potions_component
		var skill_comp: SkillComponent = character.skill_component
		
		if hp_mana_comp:
			hp_mana_bars.setup(hp_mana_comp)
		if potions_comp:
			potions.setup(potions_comp)
		if skill_comp:
			skills.setup(skill_comp)

func _on_wave_changed(text: String) -> void:
	wave_label.text = text
