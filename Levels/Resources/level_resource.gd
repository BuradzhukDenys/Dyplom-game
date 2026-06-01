@tool
extends Resource
class_name LevelResource

@export var level_name: String
@export var waves: Array[WaveResource] = []:
	set(new_waves):
		var old_size: int = waves.size()
		waves = new_waves
		
		if waves.size() > old_size:
			for i in range(waves.size()):
				if waves[i] == null:
					var new_wave: WaveResource = WaveResource.new()
					new_wave.wave_text = "Wave %d" % (i + 1)
					waves[i] = new_wave
