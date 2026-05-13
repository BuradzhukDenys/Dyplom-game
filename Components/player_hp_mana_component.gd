extends HPComponent
class_name PlayerHPManaComponent

signal mana_changed(new_value: int, type: MANA_CHANGED_TYPE)

enum MANA_CHANGED_TYPE
{
	SPEND,
	RESTORE,
	PASSIVE_RESTORE
}

var mana: int
var is_invincible: bool = false

func _ready() -> void:
	health = PlayerData.MAX_HEALTH
	mana = int(PlayerData.MAX_MANA)

func take_damage(amount: float) -> void:
	if is_invincible:
		return
		
	super.take_damage(amount)
	PlayerData.current_health = health

func spend_mana(amount: int) -> void:
	mana = clamp(mana - amount, 0, PlayerData.MAX_MANA)
	
	mana_changed.emit(mana, MANA_CHANGED_TYPE.SPEND)
	
	
func restore_mana(amount: int) -> void:
	mana = clamp(mana + amount, 0, PlayerData.MAX_MANA)
	mana_changed.emit(mana, MANA_CHANGED_TYPE.RESTORE)
