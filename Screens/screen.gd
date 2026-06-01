extends CanvasLayer
class_name Screen

func show_menu() -> void:
	get_tree().paused = true
	show()

func return_to_main_menu() -> void:
	AudioManager.stop_sfx()
	AudioManager.stop_fanfare()
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	
func restart() -> void:
	AudioManager.stop_sfx()
	AudioManager.stop_fanfare()
	PlayerData.reset_data()
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	return_to_main_menu()

func _on_restart_pressed() -> void:
	restart()
