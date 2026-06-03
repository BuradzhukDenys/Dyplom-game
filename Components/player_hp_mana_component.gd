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
var local_max_mana: float
var is_invincible: bool = false

func _ready() -> void:
	PlayerData.max_health_changed.connect(_on_max_health_changed)
	PlayerData.max_mana_changed.connect(_on_max_mana_changed)
	
	max_health = PlayerData.max_health
	health = max_health
	
	local_max_mana = PlayerData.max_mana
	mana = local_max_mana

func _process(delta: float) -> void:
	#Застовоюмо регенерацію, щоб плавно відновлювати хп
	if PlayerData.health_restore > 0.0 and health < max_health:
		health = clampf(health + PlayerData.health_restore * delta, 0, max_health)
		health_changed.emit(health, HEALTH_CHANGED_TYPE.PASSIVE_HEAL)
	if PlayerData.mana_restore > 0.0 and mana < local_max_mana:
		mana = clamp(mana + PlayerData.mana_restore * delta, 0, local_max_mana)
		mana_changed.emit(mana, MANA_CHANGED_TYPE.PASSIVE_RESTORE)

func take_damage(amount: float) -> void:
	#Перевіряємо чи гравець вразлвиий
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

#Функції для зміни максимального хп та мани від предметів
func _on_max_health_changed(new_value: float) -> void:
	var difference: float = new_value - max_health
	
	if difference == 0.0:
		return
		
	max_health = new_value
	
	if difference > 0:
		heal(difference)

func _on_max_mana_changed(new_value: float) -> void:
	var difference: float = new_value - local_max_mana
	
	if difference == 0.0:
		return
		
	local_max_mana = new_value
	
	if difference > 0:
		restore_mana(difference)
	else:
		mana = min(mana, local_max_mana)
		mana_changed.emit(mana, MANA_CHANGED_TYPE.SPEND)
