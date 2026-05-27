extends HPComponent
class_name PlayerHPManaComponent

@onready var TakeDamageTimer: Timer = $TakeDamageTimer

signal mana_changed(new_value: int, type: MANA_CHANGED_TYPE)
signal no_mana

enum MANA_CHANGED_TYPE
{
	SPEND,
	RESTORE,
	PASSIVE_RESTORE
}

var mana: float
var is_invincible: bool = false

func _ready() -> void:
	max_health = PlayerData.max_health
	health = max_health
	mana = PlayerData.max_mana

func take_damage(amount: float) -> void:
	if is_invincible:
		return
		
	is_invincible = true
	TakeDamageTimer.start()
	super.take_damage(amount)

func spend_mana(amount: float) -> void:
	if mana <= 0:
		no_mana.emit()
	mana = clamp(mana - amount, 0, PlayerData.max_mana)
	mana_changed.emit(mana, MANA_CHANGED_TYPE.SPEND)
	
func restore_mana(amount: float) -> void:
	mana = clamp(mana + amount, 0, PlayerData.max_mana)
	mana_changed.emit(mana, MANA_CHANGED_TYPE.RESTORE)

func _on_take_damage_timer_timeout() -> void:
	is_invincible = false
