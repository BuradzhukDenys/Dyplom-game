extends PanelContainer
class_name ItemTooltip

@onready var item_name_label: RichTextLabel = $VBoxContainer/ItemName
@onready var item_description_label: RichTextLabel = $VBoxContainer/ItemDescription

func _ready() -> void:
	item_name_label.text = ""
	item_description_label.text = ""

func setup(item_data: ItemData) -> void:
	if not is_node_ready():
		await ready
	item_name_label.text = item_data.get_tooltip_name_cost()
	item_description_label.text = item_data.get_tooltip_stats()
