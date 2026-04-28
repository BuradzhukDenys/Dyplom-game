extends Control

@onready var options: CanvasLayer = $Options
@onready var menu: CanvasLayer = $CanvasLayer

func _ready() -> void:
	get_tree().paused = true

func _on_options_closed() -> void:
	menu.show()

func _on_play_button_pressed() -> void:
	pass # Replace with function body.

func _on_options_button_pressed() -> void:
	options.open_menu()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_options_animation_ended() -> void:
	menu.hide()
