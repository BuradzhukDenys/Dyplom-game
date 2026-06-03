extends CanvasLayer
class_name Interface

func open() -> void:
	AudioManager.play_ui_click()
	get_tree().paused = true
	show()

func close() -> void:
	get_tree().paused = false
	hide()
