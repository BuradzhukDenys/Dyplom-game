extends CharacterBody2D
class_name Enemy

signal enemy_dead()

@onready var hit_player: AudioStreamPlayer2D = $HitPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitboxHurtboxComponent/Hitbox
@onready var hp_component: HPComponent = $HPComponent

@onready var hitbox_collision: CollisionShape2D = $HitboxHurtboxComponent/Hitbox/CollisionShape2D
@onready var hurtbox_collision: CollisionShape2D = $HitboxHurtboxComponent/Hurtbox/CollisionShape2D

@export var resource: EnemyResource

var is_dead: bool = false
var is_touching_player: bool = false
var target_direction: Vector2 = Vector2.ZERO
var another_animation_play: bool = false
var knockback_velocity: Vector2 = Vector2.ZERO
var push_velocity: Vector2 = Vector2.ZERO

var attack_cooldown: float = 0.5
var current_attack_timer: float = 0.0

var damage_flash_tween: Tween

func _ready() -> void:
	#Збільшуємо хп ворогу в залежності від хвилі
	var hp_multiplier: float = 1.0
	if PlayerData.wave_number > 1:
		hp_multiplier += (PlayerData.wave_number - 1) * 0.5
	
	hp_component.max_health = resource.health * hp_multiplier
	hp_component.health = hp_component.max_health

func _physics_process(delta: float) -> void:
	if is_dead:
		return
		
	#Визначаємо напрямок руху, та зменшуємо силу поштовхів від натовпу
	target_direction = global_position.direction_to(PlayerData.player_position)
	push_velocity = push_velocity.move_toward(Vector2.ZERO, resource.knockback_friction * delta)
	var move_velocity: Vector2 = target_direction * resource.speed
	
	if knockback_velocity != Vector2.ZERO:
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, resource.knockback_friction * delta)
	
	velocity = move_velocity + knockback_velocity + push_velocity
	
	if not another_animation_play:
		play_animation_directionaly("Move")
		
	#Перевіряємо чи позиція ворога більша за дозволену дистанцію до ворога, щоб вони
	#не смикались
	var distance_to_player: float = global_position.distance_to(PlayerData.player_position)
	var stop_distance: float = 2.0
	
	if distance_to_player > stop_distance:
		move_and_slide()
		
		#Робимо, щоб вороги штовхали оди оного
		if not another_animation_play:
			for i in get_slide_collision_count():
				var collision: KinematicCollision2D = get_slide_collision(i)
				var collider: Object = collision.get_collider()
				
				if collider is CharacterBody2D and "push_velocity" in collider:
					collider.push_velocity = target_direction * (resource.speed * 0.8)
					
	#Робимо, щоб овроги атакували гравця кожні 0.5 секунд
	if is_touching_player:
		current_attack_timer -= delta
		if current_attack_timer <= 0.0:
			attack_player()
			current_attack_timer = attack_cooldown
	else:
		current_attack_timer = 0.0

func play_animation_directionaly(anim_name: String) -> void:
	if is_dead and not anim_name.containsn("Die"):
		return
	
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
		
	if not animation.containsn("Move"):
		another_animation_play = true
	
	animated_sprite.play(animation)

func attack_player() -> void:
	var all_areas: Array[Area2D] = hitbox.get_overlapping_areas()
	for area in all_areas:
		if area is Hurtbox:
			area.take_damage(resource.damage)
			break

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area is Hurtbox:
		is_touching_player = true
		
		if current_attack_timer <= 0.0:
			attack_player()
			current_attack_timer = attack_cooldown

func _on_hitbox_area_exited(area: Area2D) -> void:
	if area is Hurtbox:
		is_touching_player = false

func _on_hp_component_health_changed(new_value: float, type: HPComponent.HEALTH_CHANGED_TYPE) -> void:
	play_hit_sound()
	
	if new_value <= 0:
		if is_dead:
			return
			
		is_dead = true
		set_physics_process(false)
		hitbox_collision.set_deferred("disabled", true)
		hurtbox_collision.set_deferred("disabled", true)
				
		PlayerData.add_experience(resource.experience_gain)
		PlayerData.add_gold(resource.gold_gain)
				
		play_animation_directionaly("Die")
		return
	
	if damage_flash_tween and damage_flash_tween.is_valid():
		damage_flash_tween.kill()
		
	damage_flash_tween = create_tween()
	animated_sprite.self_modulate = Color(0.22, 0.22, 0.22, 0.592)
	damage_flash_tween.tween_property(animated_sprite, "self_modulate", Color(1, 1, 1, 1), 0.4)
	
	match type:
		HPComponent.HEALTH_CHANGED_TYPE.TAKE_DAMAGE:
			#Застосовуємо відштовхування від атаки по ворогу
			knockback_velocity = -target_direction * resource.knockback_strength
			play_animation_directionaly("TakeDamage")

func _on_animated_sprite_2d_animation_finished() -> void:
	another_animation_play = false
	
	if animated_sprite.animation.containsn("Die"):
		enemy_dead.emit()

func play_hit_sound() -> void:
	pass
