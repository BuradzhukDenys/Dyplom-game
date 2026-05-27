extends PanelContainer
class_name WeaponBox

@onready var weapon_icon: TextureRect = $MarginContainer/TextureRect

func _ready() -> void:
	PlayerData.weapon_changed.connect(_on_weapon_changed)
	
	if PlayerData.current_weapon:
		weapon_icon.texture = PlayerData.current_weapon.texture

func _on_weapon_changed(new_weapon: SwordData) -> void:
	weapon_icon.texture = new_weapon.texture
