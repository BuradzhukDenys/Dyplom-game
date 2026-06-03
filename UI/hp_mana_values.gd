extends VBoxContainer
class_name HPManaBars

@onready var health_bar: ProgressBar = $HP/HPBar
@onready var mana_bar: ProgressBar = $Mana/Control/ManaBar
@onready var health_value_label: Label = $HP/HPBar/MarginContainer/HealthValueLabel
@onready var mana_value_label: Label = $Mana/Control/ManaBar/MarginContainer/ManaValueLabel
@onready var hp_regen_label: Label = $HP/HPBar/MarginContainer/HPRegenLabel
@onready var mana_regen_label: Label = $Mana/Control/ManaBar/MarginContainer/ManaRegenLabel

var health_tween: Tween
var mana_tween: Tween
var no_mana_tween: Tween

var player_hp_comp: PlayerHPManaComponent

func _ready() -> void:
	PlayerData.max_health_changed.connect(_on_max_health_changed)
	PlayerData.max_mana_changed.connect(_on_max_mana_changed)
	PlayerData.health_restore_changed.connect(_on_health_restore_changed)
	PlayerData.mana_restore_changed.connect(_on_mana_restore_changed)
	
	health_bar.max_value = PlayerData.max_health
	mana_bar.max_value = PlayerData.max_mana
	health_bar.value = health_bar.max_value
	mana_bar.value = mana_bar.max_value
	health_value_label.text = str(health_bar.value) + "/" + str(PlayerData.max_health)
	mana_value_label.text = str(mana_bar.value) + "/" + str(PlayerData.max_mana)
	hp_regen_label.text = "0/s"
	mana_regen_label.text = "0/s"

func setup(hp_mana_comp: PlayerHPManaComponent) -> void:
	player_hp_comp = hp_mana_comp
	
	player_hp_comp.health_changed.connect(_on_player_health_changed)
	player_hp_comp.mana_changed.connect(_on_player_mana_changed)
	player_hp_comp.no_mana.connect(_on_no_mana)
	
	health_value_label.text = str(player_hp_comp.health) + "/" + str(PlayerData.max_health)
	mana_value_label.text = str(player_hp_comp.mana) + "/" + str(PlayerData.max_mana)

func _on_player_health_changed(new_value: float, _type: HPComponent.HEALTH_CHANGED_TYPE) -> void:
	health_value_label.text = str(round(new_value)) + "/" + str(PlayerData.max_health)
	
	if health_tween and health_tween.is_valid():
		health_tween.kill()
		
	health_tween = create_tween()
	health_tween.tween_property(health_bar, "value", new_value, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_player_mana_changed(new_value: float, _type: PlayerHPManaComponent.MANA_CHANGED_TYPE) -> void:
	mana_value_label.text = str(round(new_value)) + "/" + str(PlayerData.max_mana)
	
	if mana_tween and mana_tween.is_valid():
		mana_tween.kill()
		
	mana_tween = create_tween()
	mana_tween.tween_property(mana_bar, "value", new_value, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_no_mana() -> void:
	if no_mana_tween and no_mana_tween.is_running():
		return
		
	mana_bar.modulate = Color(0.824, 0.0, 0.0, 1)
	
	mana_bar.rotation_degrees = -4
		
	no_mana_tween = create_tween()
	no_mana_tween.tween_property(mana_bar, "modulate", Color.WHITE, 0.1)
	no_mana_tween.parallel().tween_property(mana_bar, "rotation_degrees", 4, 0.1)
	no_mana_tween.tween_property(mana_bar, "rotation_degrees", 0, 0.1)
	
func _on_max_health_changed(new_value: float) -> void:
	health_bar.max_value = new_value
	
	if player_hp_comp:
		health_value_label.text = "%.1f/%.1f" % [player_hp_comp.health ,new_value]

func _on_max_mana_changed(new_value: float) -> void:
	mana_bar.max_value = new_value
	
	if player_hp_comp:
		mana_value_label.text = "%.1f/%.1f" % [player_hp_comp.mana ,new_value]

func _on_health_restore_changed(new_value: float) -> void:
	hp_regen_label.text = "%+.1f/s" % new_value
	
func _on_mana_restore_changed(new_value: float) -> void:
	mana_regen_label.text = "%+.1f/s" % new_value
