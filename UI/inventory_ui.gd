extends CanvasLayer
class_name InventoryUI

@onready var items: GridContainer = $CenterContainer/UiBackground/Items/VBoxContainer/ScrollContainer/MarginContainer/GridContainer
@export var item_container_scene: PackedScene

func _ready() -> void:
	clear_inventory()

func clear_inventory() -> void:
	for child: ItemContainer in items.get_children():
		child.queue_free()
		child = null

func show_inventory() -> void:
	clear_inventory()
	
	get_tree().paused = true
	show()
	
	for i in PlayerData.passive_items.size():
		var item_container: ItemContainer = item_container_scene.instantiate()
		items.add_child(item_container)
		item_container.setup(PlayerData.passive_items[i])

func _on_close_pressed() -> void:
	hide()
	
	if EventBus.game_end:
		return
	get_tree().paused = false
