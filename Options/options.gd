extends CanvasLayer
class_name Options

signal options_closed

const START_MENU_POSITION: Vector2 = Vector2(0, -648)

@onready var options_menu: MarginContainer = $OptionMenu
@onready var options_buttons: MarginContainer = $OptionMenu/PanelContainer/MarginContainer
@onready var fullscreen_checkbox: CheckBox = $OptionMenu/PanelContainer/MarginContainer/MarginContainer/FullScreen

@onready var master_slider: HSlider = $OptionMenu/PanelContainer/MarginContainer/MarginContainer/SoundsSettings/Sound/MasterHSlider
@onready var music_slider: HSlider = $OptionMenu/PanelContainer/MarginContainer/MarginContainer/SoundsSettings/Music/MusicHSlider
@onready var sfx_slider: HSlider = $OptionMenu/PanelContainer/MarginContainer/MarginContainer/SoundsSettings/SFX/SFXHSlider

var master_bus: int
var music_bus: int
var sfx_bus: int

var current_tween: Tween = null
var options_close: bool = false

func _ready() -> void:
	options_menu.global_position = START_MENU_POSITION
	hide()
	
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	
	master_slider.value = AudioServer.get_bus_volume_linear(master_bus)
	music_slider.value = AudioServer.get_bus_volume_linear(music_bus)
	sfx_slider.value = AudioServer.get_bus_volume_linear(sfx_bus)
	fullscreen_checkbox.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
	
	master_slider.value_changed.connect(_on_master_slider_value_changed)
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	sfx_slider.value_changed.connect(_on_sfx_slider_value_changed)
	fullscreen_checkbox.toggled.connect(_on_fullscreen_toggled)

func save_settings() -> void:
	SettingsManager.save_settings(master_slider.value, music_slider.value, sfx_slider.value, fullscreen_checkbox.button_pressed)
	
func open_menu() -> void:
	options_close = false
	show()
	switch_buttons_disable(options_buttons, true)
	if current_tween and current_tween.is_valid():
		current_tween.kill()
		
	current_tween = create_tween()
	current_tween.tween_property(options_menu, "global_position", Vector2(0, 0), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	await current_tween.finished
	switch_buttons_disable(options_buttons, false)

func switch_buttons_disable(container: Node, disable: bool) -> void:
	for child in container.get_children():
		if child is BaseButton and not child.has_meta("ignore_disable"):
			child.disabled = disable
		if child is Slider and not child.has_meta("ignore_disable"):
			child.editable = !disable
			child.scrollable = !disable
			
		if child.get_child_count() > 0:
			switch_buttons_disable(child, disable)

func _on_exit_button_pressed() -> void:
	if options_close:
		return
		
	options_close = true
	options_closed.emit()
	switch_buttons_disable(options_buttons, true)
	if current_tween and current_tween.is_valid():
		current_tween.kill()
		
	current_tween = create_tween()
	current_tween.tween_property(options_menu, "global_position", START_MENU_POSITION, 1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	current_tween.tween_callback(hide)
	
func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(value))
	save_settings()

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(value))
	save_settings()

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(value))
	save_settings()
	
func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		DisplayServer.window_set_position(DisplayServer.screen_get_position() + DisplayServer.screen_get_size() / 2 - DisplayServer.window_get_size() / 2)
		
	save_settings()
