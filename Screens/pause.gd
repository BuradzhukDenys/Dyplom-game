extends Screen
class_name PauseMenu

@onready var options: Options = $Options
@onready var controls: Interface = $Controls

func _ready() -> void:
	hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		
		if options.visible:
			options._on_exit_button_pressed()
			get_viewport().set_input_as_handled()
			return
			
		if controls.visible:
			controls._on_close_pressed()
			get_viewport().set_input_as_handled()
			return
		
		if visible:
			resume()
			get_viewport().set_input_as_handled()

func resume() -> void:
	get_tree().paused = false
	hide()

func _on_resume_pressed() -> void:
	resume()

func _on_options_pressed() -> void:
	options.open_menu()

func _on_controls_pressed() -> void:
	controls.open()
