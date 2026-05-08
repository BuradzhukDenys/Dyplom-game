extends VBoxContainer

@onready var expirience_label: Label = $EXPLabel
@onready var gold_label: Label = $GoldLabel

func _ready() -> void:
	EventBus.experience_gained.connect(_on_expirience_gained)
	EventBus.gold_gained.connect(_on_gold_gained)

func _on_expirience_gained(new_value: int) -> void:
	expirience_label.text = "EXP: " + str(new_value)

func _on_gold_gained(new_value: int) -> void:
	gold_label.text = "Gold: " + str(new_value)
