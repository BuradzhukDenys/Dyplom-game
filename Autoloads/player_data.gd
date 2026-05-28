extends Node

enum PotionType
{
	HEALING,
	MANA
}

signal experience_changed(new_value: int)
signal gold_changed(new_value: int)
signal weapon_changed(new_weapon: SwordData)

signal max_health_changed(new_value)
signal health_restore_changed(new_value)
signal max_mana_changed(new_value)
signal mana_restore_changed(new_value)
signal damage_changed(new_value)
signal speed_changed(new_value)

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

var max_health: float = 100.0:
	set(value):
		max_health = value
		max_health_changed.emit(max_health)
var max_mana: float = 100000.0:
	set(value):
		max_mana = value
		max_mana_changed.emit(max_mana)
var damage: float:
	set(value):
		damage = value
		damage_changed.emit(damage)
var speed: float = 300.0:
	set(value):
		speed = clamp(value, min_speed, max_speed)
		speed_changed.emit(speed)
		
var max_speed: float = 1450.0
var min_speed: float = 160.0

var base_health: float = 100.0
var base_mana: float = 100.0
var base_speed: float = 300.0
var base_health_restore: float = 0.0
var base_mana_restore: float = 0.0
var base_damage: float

var target_health: float = 0.0
var target_health_restore: float = 0.0
var target_mana: float = 0.0
var target_mana_restore: float = 0.0
var target_damage: float = 0.0
var target_speed: float = 0.0

var passive_health_restore: float = 0.0:
	set(value):
		passive_health_restore = value
		health_restore_changed.emit(passive_health_restore)
var passive_mana_restore: float = 0.0:
	set(value):
		passive_mana_restore = value
		mana_restore_changed.emit(passive_mana_restore)

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
	EventBus.item_bought.connect(_on_item_bought)
	
	current_weapon = ItemsManager.ITEMS[ItemsManager.ItemsType.BASE_SWORD]
	passive_items.clear()
	
	damage = current_weapon.damage
	base_damage = current_weapon.damage
	
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

func _on_item_bought(item_data: ItemData) -> void:
	if item_data is PassiveItem:
		passive_items.append(item_data)
		recalculate_stats()
	
func recalculate_stats() -> void:
	target_health = base_health
	target_health_restore = base_health_restore
	target_mana = base_mana
	target_mana_restore = base_mana_restore
	target_damage = base_damage
	target_speed = base_speed
	
	var target_percent_speed: float = 1.0
	
	for item_data: PassiveItem in passive_items:
		if (item_data.buffs & 1) != 0:
			target_health += item_data.max_health_bonus
		if (item_data.buffs & 2) != 0:
			target_health_restore += item_data.health_restore_bonus
		if (item_data.buffs & 4) != 0:
			target_mana += item_data.max_mana_bonus
		if (item_data.buffs & 8) != 0:
			target_mana_restore += item_data.mana_restore_bonus
		if (item_data.buffs & 16) != 0:
			pass
		if (item_data.buffs & 32) != 0:
			target_percent_speed += item_data.speed_percent_bonus
			target_speed += item_data.speed_bonus
			
	target_speed *= target_percent_speed
			
	max_health = target_health
	passive_health_restore = target_health_restore
	max_mana = target_mana
	passive_mana_restore = target_mana_restore
	speed = target_speed
