extends Screen
class_name PauseMenu

func _ready() -> void:
	hide()

func resume() -> void:
	get_tree().paused = false
	hide()

func _on_resume_pressed() -> void:
	resume()
