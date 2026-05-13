extends "res://Objectives/building.gd"

func interact() -> void:
	show_shop_menu()

func show_shop_menu() -> void:
	get_tree().paused = true
	objective_interface = objective_interface_scene.instantiate()
	objective_interface.interface_closed.connect(_on_interface_closed)
	add_child(objective_interface)

func _on_interface_closed() -> void:
	get_tree().paused = false
	objective_interface.queue_free()
	objective_interface = null
