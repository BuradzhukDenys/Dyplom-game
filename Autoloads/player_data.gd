extends Node

const MAX_HEALTH: float = 100.0
const MAX_MANA: float = 100000.0
const MAX_GOLD: int = 999999
const MAX_EXPIRIENCE: int = 999999
const PLAYER_RADIUS_SPAWN_ENEMIES: float = 730.0

var current_weapon: SwordData = ItemsManager.items[ItemsManager.ItemsType.BASE_SWORD]
var passive_items: Array[ItemData] = []
var skills: Array[SkillResource] = []

var player_dead: bool = false
var player_position: Vector2 = Vector2.ZERO

var experience: int = 0
var gold: int = 99999990

var current_health: float = MAX_HEALTH
var current_mana: float = MAX_MANA

var healing_potion_heal: float = 10
var mana_potion_heal: float = 15

func reset_data() -> void:
	player_dead = false
	player_position = Vector2.ZERO
	experience = 0
	gold = 99999990
	EventBus.gold_changed.emit(gold)
	EventBus.experience_changed.emit(experience)
	
func add_gold(amount: int) -> void:
	if amount < 0:
		amount = -amount
	gold = clamp(gold + amount, 0, MAX_GOLD)
	EventBus.gold_changed.emit(gold)

func add_experience(amount: int) -> void:
	if amount < 0:
		amount = -amount
	experience = clamp(experience + amount, 0, MAX_EXPIRIENCE)
	EventBus.experience_changed.emit(experience)

func spend_gold(amount: int) -> void:
	if amount < 0:
		amount = -amount
	gold = clamp(gold - amount, 0, MAX_GOLD)
	EventBus.gold_changed.emit(gold)
	
func spend_expirience(amount: int) -> void:
	if amount < 0:
		amount = -amount
	experience = clamp(experience - amount, 0, MAX_EXPIRIENCE)
	EventBus.experience_changed.emit(experience)
