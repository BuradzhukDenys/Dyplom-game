extends Enemy
class_name RangedEnemy

@export var ranged_component: RangedComponent
@onready var shoot_point: Marker2D = $ShootPoint
@onready var shoot_player: AudioStreamPlayer2D = $ShootPlayer

@export var slime_hit_sound: AudioStream

func _ready() -> void:
	super._ready()
	
	if ranged_component and resource is RangedEnemyResource:
		ranged_component.setup(resource.shootspeed)
		
func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation.containsn("Shoot"):
		if animated_sprite.frame == 4:
			shoot_player.play()
			ranged_component.shoot(shoot_point.global_position)
			
func play_hit_sound() -> void:
	if not slime_hit_sound:
		return
		
	hit_player.stream = slime_hit_sound
	hit_player.play()
