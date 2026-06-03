extends Enemy
class_name SlimeEnemy

@export var slime_hit_sound: AudioStream

func play_hit_sound() -> void:
	if not slime_hit_sound:
		return
		
	hit_player.stream = slime_hit_sound
	hit_player.play()
