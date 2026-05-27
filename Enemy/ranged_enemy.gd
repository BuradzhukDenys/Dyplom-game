extends Enemy
class_name RangedEnemy

@export var ranged_component: RangedComponent
@onready var shoot_point: Marker2D = $ShootPoint

func _ready() -> void:
	super._ready()
	
	if ranged_component and resource is RangedEnemyResource:
		ranged_component.setup(resource.shootspeed)
		
func _on_animated_sprite_2d_frame_changed() -> void:
	if animated_sprite.animation.containsn("Shoot"):
		if animated_sprite.frame == 4:
			ranged_component.shoot(shoot_point.global_position)
