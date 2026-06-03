extends Area2D
class_name Hurtbox

@export var hp_component: HPComponent
@export var fire_burn_component: FireBurnComponent

func _ready() -> void:
	if fire_burn_component:
		fire_burn_component.take_fire_damage.connect(_on_take_fire_damage)

func take_damage(amount: float) -> void:
	if hp_component:
		hp_component.take_damage(amount)

func take_durational_damage(amount: float) -> void:
	if hp_component:
		hp_component.take_durational_damage(amount)

func burn(duration: float, damage: float) -> void:
	#Коли викликається підпал, задаємо тривальсть та шкоду
	if fire_burn_component:
		fire_burn_component.setup(duration, damage)

func _on_take_fire_damage(damage: float) -> void:
	take_durational_damage(damage)
