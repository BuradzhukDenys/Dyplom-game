extends Node

enum ItemsType
{
	TORCH_SWORD,
	BASE_SWORD,
	MITHRILL_ARMOR
}

const ITEMS: Dictionary = {
	ItemsType.TORCH_SWORD: preload("res://Items/Swords/torch_sword.tres"),
	ItemsType.BASE_SWORD: preload("res://Items/Swords/base_sword.tres"),
	ItemsType.MITHRILL_ARMOR: preload("res://Items/PassiveItems/mithrill_armor.tres")
}

func get_item(index: int) -> ItemData:
	return ITEMS[index]

func all_items_count() -> int:
	return ItemsType.size()
