extends StaticBody2D
class_name Building

@onready var tooltip: Control = $Tooltip
@onready var sprite: Sprite2D = $Sprite2D

@export var target_interface: Interface

var can_interact: bool = false

var objective_interface
var opacity_tween: Tween

func _ready() -> void:
	tooltip.hide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact_with_objective") and can_interact:
		interact()

func interact() -> void:
	if target_interface:
		target_interface.open()

func _on_interaction_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("character"):
		can_interact = true
		tooltip.show()

func _on_interaction_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("character"):
		can_interact = false
		tooltip.hide()

func _on_behind_area_body_entered(body: Node2D) -> void:
	if not body.is_in_group("character"):
		return
		
	if opacity_tween and opacity_tween.is_valid():
		opacity_tween.kill()
		
	opacity_tween = create_tween()
	opacity_tween.tween_property(sprite, "self_modulate:a", 0.663, 0.3)

func _on_behind_area_body_exited(body: Node2D) -> void:
	if not body.is_in_group("character"):
		return
		
	if opacity_tween and opacity_tween.is_valid():
		opacity_tween.kill()
		
	opacity_tween = create_tween()
	opacity_tween.tween_property(sprite, "self_modulate:a", 1.0, 0.3)
