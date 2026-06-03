extends Node2D
class_name Level

@onready var shop_ui: ShopUI = $ShopUI
@onready var pause_menu: PauseMenu = $Pause
@onready var end_screen: EndScreen = $EndScreen

func _ready() -> void:
	AudioManager.play_music(AudioManager.level_music)
	EventBus.victory.connect(_on_victory)
	EventBus.defeat.connect(_on_defeat)
	
	end_screen.hide()
	
	PlayerData.reset_data()

func _on_victory() -> void:
	spawn_end_screen(true)

func _on_defeat() -> void:
	spawn_end_screen(false)

func spawn_end_screen(is_victory: bool) -> void:
	get_tree().paused = true
	end_screen.setup(is_victory)
	end_screen.show()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_menu.show_menu()
