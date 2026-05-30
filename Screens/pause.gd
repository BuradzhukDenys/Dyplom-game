extends CanvasLayer
class_name PauseMenu

func _ready() -> void:
	hide()

func show_menu() -> void:
	get_tree().paused = true
	show()

func return_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	
func restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func resume() -> void:
	get_tree().paused = false
	hide()

func _on_main_menu_pressed() -> void:
	return_to_main_menu()

func _on_restart_pressed() -> void:
	restart()

func _on_resume_pressed() -> void:
	resume()
