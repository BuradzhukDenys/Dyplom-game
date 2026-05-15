extends Node

enum ItemsType
{
	TORCH_SWORD,
	BASE_SWORD
}

const items: Dictionary = {
	ItemsType.TORCH_SWORD: preload("res://Items/torch_sword.tres"),
	ItemsType.BASE_SWORD: preload("res://Items/base_sword.tres")
}

func get_item(index: int) -> ItemData:
	return items[index]

func all_items_count() -> int:
	return ItemsType.size()
