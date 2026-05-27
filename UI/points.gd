extends VBoxContainer
class_name PointsUI

@onready var expirience_label: Label = $EXPLabel
@onready var gold_label: Label = $GoldLabel

func _ready() -> void:
	expirience_label.text = "EXP: " + str(PlayerData.experience)
	gold_label.text = "Gold: " + str(PlayerData.gold)
	PlayerData.experience_changed.connect(_on_experience_changed)
	PlayerData.gold_changed.connect(_on_gold_changed)

func _on_experience_changed(new_value: int) -> void:
	expirience_label.text = "EXP: " + str(new_value)

func _on_gold_changed(new_value: int) -> void:
	gold_label.text = "Gold: " + str(new_value)
