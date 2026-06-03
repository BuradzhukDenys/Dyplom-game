extends CanvasLayer

@onready var hp_mana_bars: HPManaBars = $MarginContainer/LeftSide/Info/HPMana
@onready var potions: PotionsUI = $MarginContainer/MarginContainer/Potions
@onready var skills: SkillsUI = $MarginContainer/PanelContainer/Skills
@onready var wave_label: Label = $MarginContainer/TopWaveCounter/VBoxContainer/WaveCount
@onready var level_label: Label = $MarginContainer/TopWaveCounter/VBoxContainer/LevelName

@export var level_resource: LevelResource

@export var stats_ui: StatsUI
@export var inventory_ui: InventoryUI

func _ready() -> void:
	inventory_ui.hide()
	stats_ui.hide()
	
	level_label.text = level_resource.level_name
	EventBus.wave_changed.connect(_on_wave_changed)
	
	#Передаємо компоненти з гравця, щоб показувати правильно дані з них
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

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("open_inventory"):
		inventory_ui.open()
	elif event.is_action_pressed("open_stats"):
		stats_ui.open()
