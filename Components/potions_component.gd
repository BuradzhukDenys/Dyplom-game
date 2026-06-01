extends Node
class_name PotionsComponent

@export var hp_mana_component: PlayerHPManaComponent

signal potion_drank(type: PlayerData.PotionType, duration: float)
signal potion_cooldown_finished(type: PlayerData.PotionType)

var cooldowns: Dictionary[PlayerData.PotionType, bool] = {
	PlayerData.PotionType.HEALING: false,
	PlayerData.PotionType.MANA: false
}

func try_drink(potion_type: PlayerData.PotionType) -> void:
	if cooldowns[potion_type]:
		return
	
	var duration: float
	match potion_type:
		PlayerData.PotionType.HEALING:
			if hp_mana_component.health >= PlayerData.max_health:
				return
				
			hp_mana_component.heal(PlayerData.healing_potion_heal)
			duration = PlayerData.healing_potion_cooldown
		PlayerData.PotionType.MANA:
			if hp_mana_component.mana >= PlayerData.max_mana:
				return
				
			hp_mana_component.restore_mana(PlayerData.mana_potion_heal)
			duration = PlayerData.mana_potion_cooldown
	
	potion_drank.emit(potion_type, duration)
	cooldowns[potion_type] = true
	
	await get_tree().create_timer(duration).timeout
	
	cooldowns[potion_type] = false
	potion_cooldown_finished.emit(potion_type)
