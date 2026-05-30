extends VBoxContainer
class_name HPManaBars

@onready var health_bar: ProgressBar = $HP/HPBar
@onready var mana_bar: ProgressBar = $Mana/Control/ManaBar
@onready var health_value_label: Label = $HP/HPBar/HealthValueLabel
@onready var mana_value_label: Label = $Mana/Control/ManaBar/ManaValueLabel

var health_tween: Tween
var mana_tween: Tween
var no_mana_tween: Tween

func _ready() -> void:
	PlayerData.max_health_changed.connect(_on_max_health_changed)
	
	health_bar.max_value = PlayerData.max_health
	mana_bar.max_value = PlayerData.max_mana
	health_bar.value = health_bar.max_value
	mana_bar.value = mana_bar.max_value
	health_value_label.text = str(PlayerData.max_health) + "/" + str(PlayerData.max_health)
	mana_value_label.text = str(PlayerData.max_mana) + "/" + str(PlayerData.max_mana)

func setup(hp_mana_comp: PlayerHPManaComponent) -> void:
	hp_mana_comp.health_changed.connect(_on_player_health_changed)
	hp_mana_comp.mana_changed.connect(_on_player_mana_changed)
	hp_mana_comp.no_mana.connect(_on_no_mana)

func _on_player_health_changed(new_value: float, _type: HPComponent.HEALTH_CHANGED_TYPE) -> void:
	health_value_label.text = str(new_value) + "/" + str(PlayerData.max_health)
	
	if health_tween and health_tween.is_valid():
		health_tween.kill()
		
	health_tween = create_tween()
	health_tween.tween_property(health_bar, "value", new_value, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_player_mana_changed(new_value: float, _type: PlayerHPManaComponent.MANA_CHANGED_TYPE) -> void:
	mana_value_label.text = str(new_value) + "/" + str(PlayerData.max_mana)
	
	if mana_tween and mana_tween.is_valid():
		mana_tween.kill()
		
	mana_tween = create_tween()
	mana_tween.tween_property(mana_bar, "value", new_value, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_no_mana() -> void:
	if no_mana_tween and no_mana_tween.is_running():
		return
		
	mana_bar.modulate = Color(0.824, 0.0, 0.0, 1)
		
	no_mana_tween = create_tween()
	no_mana_tween.tween_property(mana_bar, "modulate", Color.WHITE, 0.1)
	no_mana_tween.parallel().tween_property(mana_bar, "rotation_degrees", -4, 0.1)
	no_mana_tween.tween_property(mana_bar, "rotation", 4, 0.1)
	no_mana_tween.tween_property(mana_bar, "rotation", 0, 0.1)
	
func _on_max_health_changed(new_value) -> void:
	health_bar.max_value = new_value
	
	mana_value_label.text = str(health_bar.value) + "/" + str(health_bar.max_value)
