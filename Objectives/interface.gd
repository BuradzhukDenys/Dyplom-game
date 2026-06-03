extends CanvasLayer
class_name Interface

@export var unpasu_on_close: bool

func _ready() -> void:
	hide()

func open() -> void:
	AudioManager.play_ui_click()
	get_tree().paused = true
	show()

func close() -> void:
	if unpasu_on_close:
		get_tree().paused = false
		
	hide()

func _on_close_pressed() -> void:
	close()
