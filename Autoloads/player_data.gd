extends Node

const MAX_HEALTH: float = 100.0
const MAX_MANA: float = 100.0
const MAX_GOLD: int = 99999
const MAX_EXPIRIENCE: int = 99999
const PLAYER_RADIUS_SPAWN_ENEMIES: float = 730.0

var player_position: Vector2 = Vector2.ZERO
var player_dead: bool = false
var experience: int = 0
var gold: int = 0
var current_health: float = MAX_HEALTH
var current_mana: float = MAX_MANA
var healing_potion_heal: float = 10
var mana_potion_heal: float = 15

var can_drink_healing_potion: bool = true
var can_drink_mana_potion: bool = true
var skill1_cooldown: bool = false
var skill2_cooldown: bool = false
var skill3_cooldown: bool = false
var skill4_cooldown: bool = false
var skill5_cooldown: bool = false

func reset_data() -> void:
	player_dead = false
	player_position = Vector2.ZERO
	experience = 0
	gold = 0
	
func add_gold(amount: int) -> void:
	gold = clamp(gold + amount, 0, MAX_GOLD)
	EventBus.gold_gained.emit(gold)

func add_experience(amount: int) -> void:
	experience = clamp(experience + amount, 0, MAX_EXPIRIENCE)
	EventBus.experience_gained.emit(experience)
