extends Area2D
class_name Projectile

@onready var animation_sprite: AnimatedSprite2D = $AnimatedSprite2D

var projectile_data: ProjectileResource

var target_direction: Vector2 = Vector2.ZERO
var fly_time: float = 3.5

func setup(new_target_direction: Vector2, new_projectile_data: ProjectileResource) -> void:
	projectile_data = new_projectile_data
	
	target_direction = new_target_direction
	rotation = target_direction.angle()

func _physics_process(delta: float) -> void:
	if fly_time > 0:
		fly_time -= delta
		
		if fly_time <= 0:
			fly_time = 0
			queue_free()
	
	if target_direction:
		var velocity: Vector2 = target_direction * projectile_data.speed
		
		global_position += velocity * delta

func destroy() -> void:
	set_physics_process(false)
	animation_sprite.play("default")

func _on_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		area.take_damage(projectile_data.damage)
		destroy()

func _on_animated_sprite_2d_animation_finished() -> void:
	queue_free()
