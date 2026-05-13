extends VBoxContainer

@onready var expirience_label: Label = $EXPLabel
@onready var gold_label: Label = $GoldLabel

func _ready() -> void:
	expirience_label.text = "EXP: " + str(PlayerData.experience)
	gold_label.text = "Gold: " + str(PlayerData.gold)
	EventBus.experience_changed.connect(_on_experience_changed)
	EventBus.gold_changed.connect(_on_gold_changed)

func _on_experience_changed(new_value: int) -> void:
	expirience_label.text = "EXP: " + str(new_value)

func _on_gold_changed(new_value: int) -> void:
	gold_label.text = "Gold: " + str(new_value)
