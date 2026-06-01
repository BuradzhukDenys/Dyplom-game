extends HBoxContainer
class_name PotionsUI

@onready var healing_potion_cooldown: TextureProgressBar = $HealingPotion/Control/PanelContainer/PanelContainer/TextureProgressBar
@onready var mana_potion_cooldown: TextureProgressBar = $ManaPotion/Control/PanelContainer/PanelContainer/TextureProgressBar
@onready var healing_potion_icon: PanelContainer = $HealingPotion/Control/PanelContainer
@onready var mana_potion_icon: PanelContainer = $ManaPotion/Control/PanelContainer

var healing_cooldown_tween: Tween
var healing_scale_tween: Tween
var mana_cooldown_tween: Tween
var mana_scale_tween: Tween

func _ready() -> void:
	healing_potion_cooldown.value = 0
	mana_potion_cooldown.value = 0

func setup(potion_comp: PotionsComponent) -> void:
	potion_comp.potion_drank.connect(_on_potion_drank)
	potion_comp.potion_cooldown_finished.connect(_on_potion_cooldown_finished)

func start_cooldown(cooldown: TextureProgressBar, cooldown_tween: Tween, duration: float) -> Tween:
	if cooldown_tween and cooldown_tween.is_valid():
		cooldown_tween.kill()
	
	cooldown.value = cooldown.max_value
	var new_tween: Tween = create_tween()
	
	new_tween.tween_property(cooldown, "value", cooldown.min_value, duration)
	
	return new_tween

func play_animation_finished(scale_tween: Tween, icon: PanelContainer) -> Tween:
	if scale_tween and scale_tween.is_valid():
		scale_tween.kill()
		
	var new_tween: Tween = create_tween()
	new_tween.tween_property(icon, "scale", Vector2(1.2, 1.2), 0.15)
	new_tween.tween_property(icon, "scale", Vector2(1, 1), 0.15)
	
	return new_tween

func _on_potion_drank(type: PlayerData.PotionType, duration: float) -> void:
	match type:
		PlayerData.PotionType.HEALING:
			healing_cooldown_tween = start_cooldown(healing_potion_cooldown, healing_cooldown_tween, duration)
		PlayerData.PotionType.MANA:
			mana_cooldown_tween = start_cooldown(mana_potion_cooldown, mana_cooldown_tween, duration)

func _on_potion_cooldown_finished(type: PlayerData.PotionType) -> void:
	match type:
		PlayerData.PotionType.HEALING:
			healing_scale_tween = play_animation_finished(healing_scale_tween, healing_potion_icon)
		PlayerData.PotionType.MANA:
			mana_scale_tween = play_animation_finished(mana_scale_tween, mana_potion_icon)
