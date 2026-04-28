extends VBoxContainer

func _on_play_button_pressed() -> void:
	print("Play!!")

func _on_options_button_pressed() -> void:
	print("Options!!")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
