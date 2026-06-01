extends Node

enum ItemsType
{
	TORCH_SWORD,
	BASE_SWORD,
	DAGGER,
	HEAVY_SWORD,
	VOLCANIC_SWORD,
	AMETHYST_RING,
	BOOK_OF_MIGHT,
	BOOTS,
	CHESTPLATE,
	COMMON_SHIRT,
	EMERALD_AMULET,
	GOLD_ARMOR,
	HOLY_BOOTS,
	MAGIC_ARMOR,
	MITHRILL_ARMOR,
	RUNE_OF_DAMAGE,
	SHARPNESS_AMULET,
	SIGIL_OF_MIGHT,
	WIZARD_HAT,
	WIZARD_STAFF
}

const ITEMS: Dictionary = {
	ItemsType.TORCH_SWORD: preload("res://Items/Swords/torch_sword.tres"),
	ItemsType.BASE_SWORD: preload("res://Items/Swords/base_sword.tres"),
	ItemsType.DAGGER: preload("res://Items/Swords/dagger.tres"),
	ItemsType.HEAVY_SWORD: preload("res://Items/Swords/heavy_sword.tres"),
	ItemsType.VOLCANIC_SWORD: preload("res://Items/Swords/volcanic_sword.tres"),
	ItemsType.AMETHYST_RING: preload("res://Items/PassiveItems/amethyst_ring.tres"),
	ItemsType.BOOK_OF_MIGHT: preload("res://Items/PassiveItems/book_of_might.tres"),
	ItemsType.BOOTS: preload("res://Items/PassiveItems/boots.tres"),
	ItemsType.CHESTPLATE: preload("res://Items/PassiveItems/chestplate.tres"),
	ItemsType.COMMON_SHIRT: preload("res://Items/PassiveItems/common_shirt.tres"),
	ItemsType.EMERALD_AMULET: preload("res://Items/PassiveItems/emerald_amulet.tres"),
	ItemsType.GOLD_ARMOR: preload("res://Items/PassiveItems/gold_armor.tres"),
	ItemsType.HOLY_BOOTS: preload("res://Items/PassiveItems/holy_boots.tres"),
	ItemsType.MAGIC_ARMOR: preload("res://Items/PassiveItems/magic_armor.tres"),
	ItemsType.MITHRILL_ARMOR: preload("res://Items/PassiveItems/mithrill_armor.tres"),
	ItemsType.RUNE_OF_DAMAGE: preload("res://Items/PassiveItems/rune_of_damage.tres"),
	ItemsType.SHARPNESS_AMULET: preload("res://Items/PassiveItems/sharpness_amulet.tres"),
	ItemsType.SIGIL_OF_MIGHT: preload("res://Items/PassiveItems/sigil_of_might.tres"),
	ItemsType.WIZARD_HAT: preload("res://Items/PassiveItems/wizard_hat.tres"),
	ItemsType.WIZARD_STAFF: preload("res://Items/PassiveItems/wizard_staff.tres"),
}

func get_item(index: int) -> ItemData:
	return ITEMS[index]

func all_items_count() -> int:
	return ItemsType.size()
