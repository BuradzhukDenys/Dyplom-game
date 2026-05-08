extends HPComponent
class_name PlayerHPManaComponent

signal mana_changed(new_value: int, type: MANA_CHANGED_TYPE)

enum MANA_CHANGED_TYPE
{
	SPEND,
	RESTORE,
	PASSIVE_RESTORE
}

@export var base_mana: int = 100
var mana: int
var is_invincible: bool = false

func _ready() -> void:
	super()
	mana = base_mana

func take_damage(amount: float) -> void:
	if is_invincible:
		return
		
	super.take_damage(amount)
	PlayerData.current_health = health

func spend_mana(amount: int) -> void:
	mana = clamp(mana - amount, 0, base_mana)
	
	mana_changed.emit(mana, MANA_CHANGED_TYPE.SPEND)
	
	
func restore_mana(amount: int) -> void:
	mana = clamp(mana + amount, 0, base_mana)
	mana_changed.emit(mana, MANA_CHANGED_TYPE.RESTORE)
