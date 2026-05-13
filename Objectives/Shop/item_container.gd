extends PanelContainer

signal not_enought_gold

@onready var item_texture: TextureRect = $MarginContainer/ItemTexture
@export var item_data: ItemData
var scale_tween: Tween

func _ready() -> void:
	if item_data:
		setup(item_data)

func _on_mouse_entered() -> void:
	if scale_tween and scale_tween.is_valid():
		scale_tween.kill()
		
	scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2(1.3, 1.3), 0.15)

func _on_mouse_exited() -> void:
	if scale_tween and scale_tween.is_valid():
		scale_tween.kill()
		
	scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2(1, 1), 0.15)

func setup(new_item_data: ItemData) -> void:
	if item_data == new_item_data:
		return
		
	item_data = new_item_data
	item_texture.texture = new_item_data.texture

func buy_item() -> void:
	if not item_data:
		return
	
	if PlayerData.gold < item_data.cost:
		not_enought_gold.emit()
		return
		
	PlayerData.spend_gold(item_data.cost)
	item_texture.texture = null
	item_data = null
	
	mouse_exited.emit()

func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			buy_item()
