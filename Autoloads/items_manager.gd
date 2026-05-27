extends Node

enum ItemsType
{
	TORCH_SWORD,
	BASE_SWORD
}

const ITEMS: Dictionary = {
	ItemsType.TORCH_SWORD: preload("res://Items/Swords/torch_sword.tres"),
	ItemsType.BASE_SWORD: preload("res://Items/Swords/base_sword.tres")
}

func get_item(index: int) -> ItemData:
	return ITEMS[index]

func all_items_count() -> int:
	return ItemsType.size()
