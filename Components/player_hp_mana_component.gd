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
	PlayerData.max_health_changed.connect(_on_max_health_changed)
	
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

func _on_max_health_changed(new_value: float) -> void:
	var difference: float = new_value - max_health
	
	if difference == 0.0:
		return
		
	max_health = new_value
	
	if difference > 0:
		health += difference
		health_changed.emit(health, HEALTH_CHANGED_TYPE.HEAL)
	elif health > max_health:
		health = max_health
