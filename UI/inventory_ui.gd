extends Interface
class_name InventoryUI

@onready var items: GridContainer = $CenterContainer/UiBackground/Items/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer/GridContainer
@onready var box_container: VBoxContainer = $CenterContainer/UiBackground/Items/VBoxContainer/ScrollContainer/MarginContainer/VBoxContainer
@export var item_container_scene: PackedScene

func _ready() -> void:
	clear_inventory()

func clear_inventory() -> void:
	for child in box_container.get_children():
		if child is ItemContainer:
			child.queue_free()
	
	for child: ItemContainer in items.get_children():
		child.queue_free()
		child = null

func open() -> void:
	clear_inventory()
	
	var weapon_container: ItemContainer = item_container_scene.instantiate()
	box_container.add_child(weapon_container)
	weapon_container.setup(PlayerData.current_weapon)
	box_container.move_child(weapon_container, 0)
	weapon_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	weapon_container.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	for i in PlayerData.passive_items.size():
		var item_container: ItemContainer = item_container_scene.instantiate()
		items.add_child(item_container)
		item_container.setup(PlayerData.passive_items[i])
		
	super.open()

func _on_close_pressed() -> void:
	close()
	
	if EventBus.game_end:
		get_tree().paused = true
