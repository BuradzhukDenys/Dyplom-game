extends Enemy
class_name BatEnemy

@export var BatHitSounds: Dictionary[int, AudioStream] = {}

func play_hit_sound() -> void:
	if BatHitSounds.is_empty():
		return
		
	var hit_sound: AudioStream = BatHitSounds[randi_range(0, BatHitSounds.size() - 1)]
	hit_player.stream = hit_sound
	hit_player.play()
