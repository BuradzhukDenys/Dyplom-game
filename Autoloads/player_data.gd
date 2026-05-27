extends Node

enum PotionType
{
	HEALING,
	MANA
}

signal experience_changed(new_value: int)
signal gold_changed(new_value: int)
signal weapon_changed(new_weapon: SwordData)

const MAX_SHOP_SLOTS: int = 10
const MAX_SKILLS_SLOTS: int = 5
const MAX_GOLD: int = 999999
const MAX_EXPIRIENCE: int = 999999
const PLAYER_RADIUS_SPAWN_ENEMIES: float = 730.0

var current_weapon: SwordData:
	set(new_value):
		if current_weapon != new_value:
			current_weapon = new_value
			weapon_changed.emit(current_weapon)
		
var passive_items: Array[ItemData] = []

var player_position: Vector2 = Vector2.ZERO
var target_point: Vector2 = Vector2.ZERO

var max_health: float = 100.0
var max_mana: float = 100000.0
var max_speed: float = 300.0
var passive_mana_restore: float = 0.0
var passive_health_restore: float = 0.0

var healing_potion_heal: float = 10
var mana_potion_heal: float = 15
var healing_potion_cooldown: float = 8.0
var mana_potion_cooldown: float = 8.0

var slots_in_shop: int = 4:
	set(value):
		slots_in_shop = clampi(value, 0, MAX_SHOP_SLOTS)
var skills_slots_count: int = 2:
	set(value):
		skills_slots_count = clampi(value, 0, MAX_SKILLS_SLOTS)

var experience: int = 0:
	set(new_value):
		experience = clamp(new_value, 0, MAX_EXPIRIENCE)
		experience_changed.emit(experience)
var gold: int = 0:
	set(new_value):
		gold = clamp(new_value, 0, MAX_GOLD)
		gold_changed.emit(gold)

func _ready() -> void:
	current_weapon = ItemsManager.ITEMS[ItemsManager.ItemsType.BASE_SWORD]
	slots_in_shop = slots_in_shop
	skills_slots_count = skills_slots_count

func reset_data() -> void:
	player_position = Vector2.ZERO
	self.experience = 0
	self.gold = MAX_GOLD
	
func add_gold(amount: int) -> void:
	gold += abs(amount)

func add_experience(amount: int) -> void:
	experience += abs(amount)

func spend_gold(amount: int) -> void:
	gold -= abs(amount)
	
func spend_expirience(amount: int) -> void:
	experience -= abs(amount)
