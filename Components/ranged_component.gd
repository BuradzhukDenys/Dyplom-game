extends Node
class_name RangedComponent

@export var projectile_scene: PackedScene
@export var projectile_data: ProjectileResource
@onready var shootspeed_timer: Timer = $Timer

var can_shoot: bool = false
var current_shootspeed: float = 1.0

func setup(shootspeed: float) -> void:
	current_shootspeed = shootspeed
	shootspeed_timer.wait_time = current_shootspeed
	shootspeed_timer.start()

func _process(_delta: float) -> void:
	if owner.global_position.distance_squared_to(PlayerData.player_position) <= 62500.0:
		can_shoot = true
	else:
		can_shoot = false
		
	if can_shoot and shootspeed_timer.time_left <= 0.0:
		shootspeed_timer.start()
		
		if owner.has_method("play_animation_directionaly"):
			owner.play_animation_directionaly("Shoot")

func shoot(shoot_position: Vector2) -> void:
	if not projectile_scene:
		return
	
	var projectile: Projectile = projectile_scene.instantiate()
	get_tree().current_scene.add_child(projectile)
	
	projectile.global_position = shoot_position
	
	var current_direction = owner.global_position.direction_to(PlayerData.target_point)
	projectile.setup(current_direction, projectile_data)
