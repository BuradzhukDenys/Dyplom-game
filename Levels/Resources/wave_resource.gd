@tool
extends Resource
class_name WaveResource

@export var wave_text: String = "Wave 1"
@export var wave_offset: float
@export var wave_enemies: Array[GroupResource]:
	set(new_wave_enemies):
		var old_size: int = wave_enemies.size()
		wave_enemies = new_wave_enemies
		
		if wave_enemies.size() > old_size:
			for i in range(wave_enemies.size()):
				if wave_enemies[i] == null:
					wave_enemies[i] = GroupResource.new()
