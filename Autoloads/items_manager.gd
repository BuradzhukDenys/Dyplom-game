extends Node

enum ItemsType
{
	TORCH_SWORD,
	TEST_SWORD
}

const items: Dictionary = {
	ItemsType.TORCH_SWORD: preload("res://Items/torch_sword.tres"),
	ItemsType.TEST_SWORD: preload("res://Items/test_sword.tres")
}

func get_item(index: int) -> ItemData:
	return items[index]

func all_items_count() -> int:
	return ItemsType.size()
