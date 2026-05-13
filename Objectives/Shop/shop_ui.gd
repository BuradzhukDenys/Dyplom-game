extends CanvasLayer

signal interface_closed

@export var item_container_scene: PackedScene
@export var item_information_scene: PackedScene

@onready var items: GridContainer = $CenterContainer/UiBackground/Items/GridContainer
@onready var player_gold_label: Label = $CenterContainer/UiBackground/Intearctive/VBoxContainer/Control/PlayerGoldLabel
@onready var refresh_cost_label: Label = $CenterContainer/UiBackground/Intearctive/VBoxContainer/RefreshCostLabel
var max_items: int = GameData.slots_in_shop
var timer_to_show_tooltip: Timer = Timer.new()
var current_tooltip: PanelContainer = null
var hovered_item_data: ItemData = null

var not_enough_money_tween: Tween
var refresh_cost: float = 3

func _ready() -> void:
	player_gold_label.text = "Gold: %d" % PlayerData.gold
	refresh_cost_label.text = "Refresh cost - %.0f gold" % refresh_cost
	timer_to_show_tooltip.timeout.connect(_on_timer_to_show_tooltip_timeout)
	timer_to_show_tooltip.one_shot = true
	add_child(timer_to_show_tooltip)
	
	for i in max_items:
		var random_item: int = randi_range(0, ItemsManager.all_items_count() - 1)
		var item_container: PanelContainer = item_container_scene.instantiate()
		items.add_child(item_container)
		item_container.setup(ItemsManager.get_item(random_item))
		
		item_container.not_enought_gold.connect(_on_not_enought_gold)
		item_container.mouse_entered.connect(_on_item_container_mouse_entered.bind(item_container))
		item_container.mouse_exited.connect(_on_item_container_mouse_exited)
		
	EventBus.gold_changed.connect(_on_gold_changed)

func _on_item_container_mouse_entered(container: PanelContainer) -> void:
	var data: ItemData = container.item_data
	
	if not data:
		return
	
	hovered_item_data = data
	timer_to_show_tooltip.start(0.4)
	
func _on_item_container_mouse_exited() -> void:
	timer_to_show_tooltip.stop()
	hovered_item_data = null
	
	if current_tooltip:
		current_tooltip.queue_free()
		current_tooltip = null
	
func _on_timer_to_show_tooltip_timeout() -> void:
	if not hovered_item_data or current_tooltip:
		return
	
	current_tooltip = item_information_scene.instantiate()
	current_tooltip.modulate.a = 0.0
	add_child(current_tooltip)
	current_tooltip.setup(hovered_item_data)
	
	var target_pos = get_viewport().get_mouse_position() + Vector2(15, 15)
	var screen_size = get_viewport().get_visible_rect().size
	
	await get_tree().process_frame
	
	if not is_instance_valid(current_tooltip): return
	
	if target_pos.x + current_tooltip.size.x > screen_size.x:
		target_pos.x = get_viewport().get_mouse_position().x - current_tooltip.size.x - 15
		
	if target_pos.y + current_tooltip.size.y > screen_size.y:
		target_pos.y = screen_size.y - current_tooltip.size.y - 10
		
	current_tooltip.global_position = target_pos
	current_tooltip.modulate.a = 1.0

func show_error() -> void:
	if not_enough_money_tween and not_enough_money_tween.is_valid():
		not_enough_money_tween.kill()
		
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
		
	refresh_cost += refresh_cost * 0.1
	PlayerData.spend_gold(int(refresh_cost))
	refresh_cost_label.text = "Refresh cost - %.0f gold" % refresh_cost
	
func _on_gold_changed(new_value: int) -> void:
	player_gold_label.text = "Gold: %d" % new_value
	
func _on_not_enought_gold() -> void:
	show_error()

func _on_close_pressed() -> void:
	interface_closed.emit()

func _on_refresh_pressed() -> void:
	if PlayerData.gold < refresh_cost:
		show_error()
		return
		
	refresh_shop()
