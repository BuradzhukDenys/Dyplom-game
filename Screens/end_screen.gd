extends CanvasLayer

@onready var end_screen_label: Label = $MarginContainer/CenterContainer/PanelContainer/VBoxContainer/Control/Label
@onready var main_menu_button: Button = $MarginContainer/CenterContainer/PanelContainer/VBoxContainer/HBoxContainer2/MainMenu
@onready var restart_button: Button = $MarginContainer/CenterContainer/PanelContainer/VBoxContainer/HBoxContainer2/Restart
@onready var items_button: Button = $MarginContainer/CenterContainer/PanelContainer/VBoxContainer/Items

var label_tween: Tween
var label_color_tween: Tween

func _ready() -> void:
	end_screen_label.text = ""
	end_screen_label.modulate = Color(1.0, 1.0, 1.0, 1.0)
	end_screen_label.rotation = 0.0

func setup(is_victory: bool) -> void:
	if is_victory:
		on_victory()
	else:
		on_defeat()

func on_victory() -> void:
	end_screen_label.text = "Victory"
	end_screen_label.modulate = Color(0.877, 0.0, 0.0, 1.0)
	
	start_rotation_tween_deg(25, 1)
	if label_color_tween and label_color_tween.is_valid():
		label_color_tween.kill()
		
	label_color_tween = create_tween()
	
	label_color_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	label_color_tween.set_loops()
	
	label_color_tween.tween_property(end_screen_label, "modulate", Color(0.988, 0.467, 0.012, 1.0), 0.4)
	label_color_tween.tween_property(end_screen_label, "modulate", Color(0.843, 0.761, 0.078, 1.0), 0.4)
	label_color_tween.tween_property(end_screen_label, "modulate", Color(0.318, 0.637, 0.0, 1.0), 0.4)
	label_color_tween.tween_property(end_screen_label, "modulate", Color(0.035, 0.631, 1.0, 1.0), 0.4)
	label_color_tween.tween_property(end_screen_label, "modulate", Color(0.158, 0.321, 1.0, 1.0), 0.4)
	label_color_tween.tween_property(end_screen_label, "modulate", Color(0.549, 0.12, 0.977, 1.0), 0.4)
	label_color_tween.tween_property(end_screen_label, "modulate", Color(0.877, 0.0, 0.0, 1.0), 0.4)
	
func on_defeat() -> void:
	end_screen_label.text = "Defeat"
	end_screen_label.modulate = Color(0.877, 0.0, 0.0, 1.0)
	
	start_rotation_tween_deg(25, 1)
	
func start_rotation_tween(tween_rotation: float, time: float, loops: int = 0) -> void:
	end_screen_label.rotation = -tween_rotation
	
	if label_tween and label_tween.is_valid():
		label_tween.kill()
		
	label_tween = create_tween()
	
	label_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	label_tween.set_loops(loops)
	
	label_tween.tween_property(end_screen_label, "rotation", tween_rotation, time)
	label_tween.tween_property(end_screen_label, "rotation", -tween_rotation, time)
	
func start_rotation_tween_deg(rotation_degrees: float, time: float, loops: int = 0) -> void:
	end_screen_label.rotation_degrees = -rotation_degrees
	
	if label_tween and label_tween.is_valid():
		label_tween.kill()
		
	label_tween = create_tween()
	
	label_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	label_tween.set_loops(loops)
	
	label_tween.tween_property(end_screen_label, "rotation_degrees", rotation_degrees, time)
	label_tween.tween_property(end_screen_label, "rotation_degrees", -rotation_degrees, time)
	
func return_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	
func restart() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	
func show_items() -> void:
	print("Items: %s" % PlayerData.current_weapon.item_name)

func _on_main_menu_pressed() -> void:
	return_to_main_menu()

func _on_restart_pressed() -> void:
	restart()

func _on_items_pressed() -> void:
	show_items()
