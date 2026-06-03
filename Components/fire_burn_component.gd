extends Node
class_name FireBurnComponent

signal take_fire_damage(damage: float)

var fire_burn_duration: float = 0.0
var fire_burn_damage: float = 0.0
var tick_timer: float = 0.0

func setup(new_fire_burn_duration: float, new_fire_burn_damage: float) -> void:
	fire_burn_damage = new_fire_burn_damage
	fire_burn_duration = new_fire_burn_duration
	tick_timer = 0.0
	owner.modulate = Color(1.0, 0.388, 0.0, 1.0)
	
func _process(delta: float) -> void:
	#Якщо підпалили, то віднімаємо тривалість підпалу щокадру, та додаємо тіки
	#до наступного нанесення шкоди
	if fire_burn_duration > 0.0:
		fire_burn_duration -= delta
		tick_timer += delta
		
		if tick_timer >= 1.0:
			tick_timer -= 1.0
			take_fire_damage.emit(fire_burn_damage)
			
		if fire_burn_duration <= 0.0:
			fire_burn_duration = 0
			tick_timer = 0.0
			owner.modulate = Color(1, 1, 1, 1)
