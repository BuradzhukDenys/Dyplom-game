extends StaticBody2D
class_name Building

@export var objective_interface_scene: PackedScene

@onready var tooltip: Control = $Tooltip
@onready var sprite: Sprite2D = $Sprite2D

var can_interact: bool = false

var objective_interface
var oppacity_tween: Tween

func _ready() -> void:
	tooltip.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_with_objective") and can_interact:
		interact()

func interact() -> void:
	get_tree().paused = true
	objective_interface = objective_interface_scene.instantiate()
	objective_interface.interface_closed.connect(_on_interface_closed)
	get_tree().current_scene.add_child(objective_interface)

func _on_interface_closed() -> void:
	get_tree().paused = false
	objective_interface.queue_free()
	objective_interface = null

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Character"):
		can_interact = true
		tooltip.show()

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("Character"):
		can_interact = false
		tooltip.hide()

func _on_behind_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Character"):
		return
		
	if oppacity_tween and oppacity_tween.is_valid():
		oppacity_tween.kill()
		
	oppacity_tween = create_tween()
	oppacity_tween.tween_property(sprite, "self_modulate:a", 0.663, 0.3)

func _on_behind_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("Character"):
		return
		
	if oppacity_tween and oppacity_tween.is_valid():
		oppacity_tween.kill()
		
	oppacity_tween = create_tween()
	oppacity_tween.tween_property(sprite, "self_modulate:a", 1.0, 0.3)
