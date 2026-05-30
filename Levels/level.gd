extends Node2D
class_name Level

@onready var shop_ui: ShopUI = $ShopUI
@onready var inventory_ui: InventoryUI = $InventoryUI
@onready var stats_ui: StatsUI = $Stats
@onready var pause_menu: PauseMenu = $Pause

@export var end_screen_scene: PackedScene

func _ready() -> void:
	PlayerData.reset_data()
	
	EventBus.victory.connect(_on_victory)
	EventBus.defeat.connect(_on_defeat)
	EventBus.inventory_opened.connect(_on_inventory_opened)
	EventBus.stats_opened.connect(_on_stats_opened)
	
	shop_ui.hide()
	inventory_ui.hide()

func _on_victory() -> void:
	spawn_end_screen(true)

func _on_defeat() -> void:
	spawn_end_screen(false)

func spawn_end_screen(is_victory: bool) -> void:
	get_tree().paused = true
	var end_screen: EndScreen = end_screen_scene.instantiate()
	add_child(end_screen)
	end_screen.setup(is_victory)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_Y and event.is_pressed():
			EventBus.game_end = true
			EventBus.victory.emit()
		elif event.keycode == KEY_B and event.is_pressed():
			EventBus.game_end = true
			EventBus.defeat.emit()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_menu.show_menu()

func _on_inventory_opened() -> void:
	inventory_ui.show_inventory()
	
func _on_stats_opened() -> void:
	stats_ui.show_stats()
