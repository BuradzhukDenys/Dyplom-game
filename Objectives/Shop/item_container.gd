extends PanelContainer
class_name ItemContainer

signal clicked(item_data: ItemData, container: ItemContainer)

@export var item_information_scene: PackedScene
@onready var item_texture: TextureRect = $MarginContainer/ItemTexture

@export var item_data: ItemData
var scale_tween: Tween

var timer_to_show_tooltip: Timer = Timer.new()
var current_tooltip: ItemTooltip = null

func _ready() -> void:
	timer_to_show_tooltip.timeout.connect(_show_tooltip)
	timer_to_show_tooltip.one_shot = true
	add_child(timer_to_show_tooltip)
	
	timer_to_show_tooltip.process_mode = Node.PROCESS_MODE_ALWAYS
	
	if item_data:
		setup(item_data)

func _on_mouse_entered() -> void:
	if not item_data:
		return
	
	if scale_tween and scale_tween.is_valid():
		scale_tween.kill()
		
	scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.15)
	
	timer_to_show_tooltip.start(0.4)

func _on_mouse_exited() -> void:
	if scale_tween and scale_tween.is_valid():
		scale_tween.kill()
		
	scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2(1, 1), 0.15)
	
	timer_to_show_tooltip.stop()
	
	if current_tooltip:
		current_tooltip.queue_free()
		current_tooltip = null

func setup(new_item_data: ItemData) -> void:
	if item_data != new_item_data:
		item_data = new_item_data
		
	if item_data:
		item_texture.texture = new_item_data.texture
	else:
		item_texture.texture = null
		mouse_exited.emit()

func _show_tooltip() -> void:
	if not item_data or current_tooltip:
		return
	
	current_tooltip = item_information_scene.instantiate()
	current_tooltip.modulate.a = 0.0
	current_tooltip.top_level = true
	add_child(current_tooltip)
	current_tooltip.setup(item_data)
	
	current_tooltip.reset_size()
	await get_tree().process_frame
	if not is_instance_valid(current_tooltip): return
	
	var screen_size: Vector2 = get_viewport().get_visible_rect().size
	var tooltip_size: Vector2 = current_tooltip.size
	var target_pos: Vector2 = get_global_mouse_position() + Vector2(15, 15)
	
	if target_pos.x + tooltip_size.x > screen_size.x:
		target_pos.x = get_global_mouse_position().x - tooltip_size.x - 15
		
	if target_pos.y + tooltip_size.y > screen_size.y:
		target_pos.y = screen_size.y - tooltip_size.y - 10
		
	current_tooltip.global_position = target_pos
	current_tooltip.modulate.a = 1.0

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if item_data != null:
				clicked.emit(item_data, self)
