extends Control

const level_scene: PackedScene = preload("res://Levels/level.tscn")

@onready var options: CanvasLayer = $Options
@onready var menu: CanvasLayer = $CanvasLayer

func _ready() -> void:
	get_tree().paused = true

func _on_play_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_packed(level_scene)

func _on_options_button_pressed() -> void:
	options.open_menu()

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_options_animation_ended() -> void:
	menu.hide()
	
func _on_options_closed() -> void:
	menu.show()
