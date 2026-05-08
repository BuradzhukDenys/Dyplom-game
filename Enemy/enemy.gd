extends CharacterBody2D

signal enemy_dead()

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitboxHurtboxComponent/Hitbox

@export var resource: EnemyResource

var is_touching_player: bool = false
var target_direction: Vector2 = Vector2.ZERO
var another_animation_play: bool = false
var knockback_velocity: Vector2 = Vector2.ZERO
var push_velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	target_direction = global_position.direction_to(PlayerData.player_position)
	
	push_velocity = push_velocity.move_toward(Vector2.ZERO, resource.knockback_friction * delta)
	if knockback_velocity != Vector2.ZERO:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, resource.knockback_friction * delta)
		velocity = knockback_velocity + push_velocity
	elif another_animation_play:
		velocity = push_velocity
	else:
		#velocity = (resource.speed * target_direction) + push_velocity
		play_animation_directionaly("Jump")
		
	var distance_to_player: float = global_position.distance_to(PlayerData.player_position)
	var stop_distance: float = 2.0
	
	try_attack()
	if distance_to_player > stop_distance:
		move_and_slide()
		
		if not another_animation_play:
			for i in get_slide_collision_count():
				var collision: KinematicCollision2D = get_slide_collision(i)
				var collider: Object = collision.get_collider()
				
				if collider is CharacterBody2D and "push_velocity" in collider:
					collider.push_velocity = target_direction * (resource.speed * 0.8)

func play_animation_directionaly(anim_name: String) -> void:
	var animation_direction: float = Vector2.RIGHT.dot(target_direction)
	var animation: String = anim_name
	
	animated_sprite.flip_h = false
	if animation_direction <= 1.0 and animation_direction > 0.7:
		animation += "LeftRight"
	elif animation_direction >= -1.0 and animation_direction < -0.7:
		animation += "LeftRight"
		animated_sprite.flip_h = true
	elif animation_direction <= 0.7 and animation_direction >= -0.7 and target_direction.y <= 0:
		animation += "Up"
	elif animation_direction <= 0.7 and animation_direction >= -0.7 and target_direction.y > 0:
		animation += "Down"
	
	if anim_name == "Die":
		animation = anim_name
	animated_sprite.play(animation)

func attack_player(area: Area2D) -> void:
	area.get_hp_component().take_damage(resource.damage)
	
func try_attack() -> void:
	if is_touching_player:
		var all_areas: Array[Area2D] = hitbox.get_overlapping_areas()
		if not all_areas.is_empty():
			attack_player(all_areas[0])

func _on_hitbox_area_entered(_area: Area2D) -> void:
	is_touching_player = true

func _on_hitbox_area_exited(_area: Area2D) -> void:
	is_touching_player = false

func _on_hp_component_health_changed(new_value: float, type) -> void:
	another_animation_play = true
	
	knockback_velocity = -target_direction * resource.knockback_strength
	if new_value > 0:
		play_animation_directionaly("TakeDamage")
		animated_sprite.self_modulate = Color(0.9, 0, 0, 0.8)
	else:
		PlayerData.add_experience(resource.expirience_gain)
		PlayerData.add_gold(resource.gold_gain)
		play_animation_directionaly("Die")

func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite.self_modulate = Color(1, 1, 1, 1)
	another_animation_play = false
	if animated_sprite.animation.containsn("Die"):
		enemy_dead.emit()
