extends Node2D
class_name Level

@export var end_screen_scene: PackedScene

func _ready() -> void:
	PlayerData.reset_data()
	
	EventBus.victory.connect(_on_victory)
	EventBus.defeat.connect(_on_defeat)

func _on_victory() -> void:
	spawn_end_screen(true)

func _on_defeat() -> void:
	spawn_end_screen(false)

func spawn_end_screen(is_victory: bool) -> void:
	get_tree().paused = true
	var end_screen = end_screen_scene.instantiate()
	add_child(end_screen)
	end_screen.setup(is_victory)

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_Y and event.is_pressed():
			EventBus.victory.emit()
		elif event.keycode == KEY_X and event.is_pressed():
			EventBus.defeat.emit()
