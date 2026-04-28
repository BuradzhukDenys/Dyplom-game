extends CanvasLayer

signal options_closed

const START_MENU_POSITION: Vector2 = Vector2(0, -648)

@onready var options_menu: MarginContainer = $OptionMenu
@onready var options_buttons: MarginContainer = $OptionMenu/PanelContainer/MarginContainer

var current_tween: Tween = null

func _ready() -> void:
	options_menu.global_position = START_MENU_POSITION
	hide()

func open_menu() -> void:
	show()
	switch_buttons_disable(options_buttons, true)
	if current_tween and current_tween.is_valid():
		current_tween.kill()
		
	current_tween = create_tween()
	current_tween.tween_property(options_menu, "global_position", Vector2(0, 0), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	current_tween.tween_callback(switch_buttons_disable.bind(options_buttons, false))

func switch_buttons_disable(container: Node, disable: bool) -> void:
	for child in container.get_children():
		if child is BaseButton and not child.has_meta("ignore_disable"):
			child.disabled = disable
			
		if child.get_child_count() > 0:
			switch_buttons_disable(child, disable)

func _on_exit_button_pressed() -> void:
	options_closed.emit()
	switch_buttons_disable(options_buttons, true)
	if current_tween and current_tween.is_valid():
		current_tween.kill()
		
	current_tween = create_tween()
	current_tween.tween_property(options_menu, "global_position", START_MENU_POSITION, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	current_tween.tween_callback(hide)
	
func _on_full_screen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
