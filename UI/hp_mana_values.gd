extends VBoxContainer

@onready var health_bar: ProgressBar = $HP/HPBar
@onready var mana_bar: ProgressBar = $Mana/Control/ManaBar
@onready var health_value_label: Label = $HP/HPBar/HealthValueLabel
@onready var mana_value_label: Label = $Mana/Control/ManaBar/ManaValueLabel

var health_tween: Tween
var mana_tween: Tween
var no_mana_tween: Tween

func _ready() -> void:
	EventBus.player_health_changed.connect(_on_player_health_changed)
	EventBus.player_mana_changed.connect(_on_player_mana_changed)
	EventBus.no_mana.connect(_on_no_mana)
	
	health_bar.max_value = PlayerData.MAX_HEALTH
	mana_bar.max_value = PlayerData.MAX_MANA
	health_bar.value = PlayerData.current_health
	mana_bar.value = PlayerData.current_mana
	health_value_label.text = str(PlayerData.current_health) + "/" + str(PlayerData.MAX_HEALTH)
	mana_value_label.text = str(PlayerData.current_mana) + "/" + str(PlayerData.MAX_MANA)

func _on_player_health_changed(new_value: float) -> void:
	health_value_label.text = str(new_value) + "/" + str(PlayerData.MAX_HEALTH)
	
	if health_tween and health_tween.is_valid():
		health_tween.kill()
		
	health_tween = create_tween()
	health_tween.tween_property(health_bar, "value", new_value, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func _on_player_mana_changed(new_value: float) -> void:
	mana_value_label.text = str(new_value) + "/" + str(PlayerData.MAX_MANA)
	
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
	no_mana_tween.parallel().tween_property(mana_bar, "rotation", deg_to_rad(-4), 0.1)
	no_mana_tween.tween_property(mana_bar, "rotation", deg_to_rad(4), 0.1)
	no_mana_tween.tween_property(mana_bar, "rotation", deg_to_rad(0), 0.1)
