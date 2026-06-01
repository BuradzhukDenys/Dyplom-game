extends Skill
class_name SkillProjectile

var fly_time: float = 0.0
var fly_speed: float = 0.0
var velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	global_position += velocity * delta
	
	if fly_time > 0: 
		fly_time -= delta
		
		if fly_time <= 0:
			fly_time = 0
			destroy()

func setup_projectile(new_fly_time: float, new_fly_speed: float) -> void:
	fly_time = new_fly_time
	fly_speed = new_fly_speed
	
	velocity = direction * fly_speed

func destroy() -> void:
	queue_free()

func _on_hitbox_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox") and area is Hurtbox:
		super._on_hitbox_entered(area)
		
		animation.play("hit")
		set_physics_process(false)
		$CollisionShape2D.set_deferred("disabled", true)
