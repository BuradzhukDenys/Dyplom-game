extends Skill

@onready var ice_hammer_casted_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

func delete() -> void:
	hide()
	
	if ice_hammer_casted_player.playing:
		await ice_hammer_casted_player.finished
	
	queue_free()
