extends Interface
class_name ShopUI

@export var item_container_scene: PackedScene
@export var item_information_scene: PackedScene

@onready var items: GridContainer = $CenterContainer/UiBackground/Items/GridContainer
@onready var player_gold_label: Label = $CenterContainer/UiBackground/Intearctive/VBoxContainer/Control/PlayerGoldLabel
@onready var refresh_cost_label: Label = $CenterContainer/UiBackground/Intearctive/VBoxContainer/RefreshCostLabel

const BASE_REFRESH_COST: int = 3

var max_items: int
var half_of_items: float
var free_refresh: bool = false

var not_enough_money_tween: Tween
var refresh_cost: float = BASE_REFRESH_COST

func _ready() -> void:
	max_items = PlayerData.slots_in_shop
	half_of_items = floori(max_items / 2.0)
	player_gold_label.text = "Gold: %d" % PlayerData.gold
	refresh_cost_label.text = "Refresh cost - %d gold" % refresh_cost
	
	for i in max_items:
		var random_item: int = randi_range(0, ItemsManager.all_items_count() - 1)
		var item_container: ItemContainer = item_container_scene.instantiate()
		items.add_child(item_container)
		item_container.setup(ItemsManager.get_item(random_item))
		
		item_container.clicked.connect(_on_slot_clicked)
		
	PlayerData.gold_changed.connect(_on_gold_changed)

func show_error() -> void:
	if not_enough_money_tween and not_enough_money_tween.is_running():
		return
		
	not_enough_money_tween = create_tween()
	player_gold_label.self_modulate = Color(0.592, 0.0, 0.0, 1.0)
	not_enough_money_tween.tween_property(player_gold_label, "self_modulate", Color.WHITE, 0.1)
	not_enough_money_tween.parallel().tween_property(player_gold_label, "rotation_degrees", 5, 0.1)
	not_enough_money_tween.tween_property(player_gold_label, "rotation_degrees", -5, 0.1)
	not_enough_money_tween.tween_property(player_gold_label, "rotation_degrees", 0, 0.1)

func refresh_shop() -> void:
	for container in items.get_children():
		var random_item_index: int = randi_range(0, ItemsManager.all_items_count() - 1)
		container.setup(ItemsManager.get_item(random_item_index))
		
	if not free_refresh:
		PlayerData.spend_gold(int(refresh_cost))
		refresh_cost += refresh_cost * 0.1
	else:
		free_refresh = false
	refresh_cost_label.text = "Refresh cost - %d gold" % refresh_cost
	
func _on_gold_changed(new_value: int) -> void:
	player_gold_label.text = "Gold: %d" % new_value

func _on_close_pressed() -> void:
	close()

func _on_refresh_pressed() -> void:
	if PlayerData.gold < refresh_cost:
		show_error()
		return
		
	refresh_shop()

func check_free_refresh() -> void:
	var empty_containers: int = 0
	for item_container: ItemContainer in items.get_children():
		if item_container.item_data == null:
			empty_containers += 1
			
		if empty_containers >= half_of_items:
			free_refresh = true
			refresh_cost_label.text = "Refresh cost - FREE"
			break
	
func _on_slot_clicked(item_data: ItemData, container: ItemContainer) -> void:
	if PlayerData.gold < item_data.cost:
		show_error()
		return
		
	EventBus.item_bought.emit(item_data)
	PlayerData.spend_gold(item_data.cost)
	container.setup(null)
	check_free_refresh()
