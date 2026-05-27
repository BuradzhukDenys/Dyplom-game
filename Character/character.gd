extends CharacterBody2D
class_name Character

#region nodes
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hp_mana_component: PlayerHPManaComponent = $PlayerHPManaComponent
@onready var potions_component: PotionsComponent = $PotionsComponent
@onready var skill_component: SkillComponent = $SkillComponent
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var hitbox: Area2D = $HitboxHurtboxComponent/Hitbox
@onready var hitbox_collision: CollisionShape2D = $HitboxHurtboxComponent/Hitbox/CollisionShape2D
@onready var hurtbox_collision: CollisionShape2D = $HitboxHurtboxComponent/Hurtbox/CollisionShape2D
@onready var healing_particles: GPUParticles2D = $ParticleManager/HealParticles
@onready var mana_particles: GPUParticles2D = $ParticleManager/ManaParticles
@onready var target_point: Marker2D = $TargetPoint
#endregion

#region values
var speed: float
var damage: float

const SPEED_WHEN_ATTACK: float = 0.5
const SPEED_TAKE_DAMAGE_SLOWNESS: float = 0.8
var last_direction: Vector2 = Vector2.DOWN
var can_attack: bool = true
#endregion

#region tweens
var mana_restore_tween: Tween
var heal_tween: Tween
#endregion

#region states
enum States
{
	IDLE,
	MOVE,
	ATTACK,
	TAKE_DAMAGE,
	DEAD
}

var current_state: States = States.IDLE
#endregion

func _ready() -> void:
	speed = PlayerData.max_speed
	damage = PlayerData.current_weapon.damage

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and can_attack and current_state in [States.IDLE, States.MOVE]:
		switch_state(States.ATTACK)
		
	if event.is_action_pressed("drink_healing_potion"):
		potions_component.try_drink(PlayerData.PotionType.HEALING)
	if event.is_action_pressed("drink_mana_potion"):
		potions_component.try_drink(PlayerData.PotionType.MANA)
		
	for i in range(1, 6):
		if event.is_action_pressed("skill" + str(i)):
			skill_component.try_cast_skill_at_slot(i, last_direction)
			break

func _physics_process(delta: float) -> void:
	process_state(delta)
	move_and_slide()
	
	PlayerData.player_position = global_position 
	PlayerData.target_point = target_point.global_position

#region states_handle
func _enter_state(state: States) -> void:
	match state:
		States.IDLE:
			play_animation_directionaly("Idle")
		States.ATTACK:
			can_attack = false
			attack_cooldown_timer.start(PlayerData.current_weapon.attack_interval)
			play_animation_directionaly("Attack")
		States.TAKE_DAMAGE:
			play_animation_directionaly("TakeDamage")
		States.DEAD:
			play_animation_directionaly("Die")
			set_physics_process(false)
			set_process_unhandled_input(false)
			
			hitbox_collision.set_deferred("disabled", true)
			hurtbox_collision.set_deferred("disabled", true)

func _exit_state(state: States) -> void:
	match state:
		States.IDLE:
			pass
		States.MOVE:
			pass
		States.ATTACK, States.TAKE_DAMAGE:
			animated_sprite.self_modulate = Color(1, 1, 1, 1)
		States.DEAD:
			pass

func process_state(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	match current_state:
		States.IDLE:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.y = move_toward(velocity.y, 0, speed)
			if direction:
				switch_state(States.MOVE)
		States.MOVE:
			velocity = direction * speed
			if direction:
				if abs(direction.x) > abs(direction.y):
					last_direction = Vector2(signf(direction.x), 0)
				else:
					last_direction = Vector2(0, signf(direction.y))
				play_animation_directionaly("Move")
			else:
				switch_state(States.IDLE)
		States.ATTACK:
			velocity = direction * (speed * SPEED_WHEN_ATTACK)
		States.TAKE_DAMAGE:
			velocity = direction * (speed * SPEED_TAKE_DAMAGE_SLOWNESS)
		States.DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, speed)

func switch_state(new_state: States) -> void:
	if current_state == new_state:
		return
		
	_exit_state(current_state)
	
	current_state = new_state
	
	_enter_state(current_state)
#endregion

func play_animation_directionaly(anim_name: String) -> void:
	var animation: String = anim_name
	match last_direction:
		Vector2(1, 0): animation += "Right"
		Vector2(-1, 0): animation += "Left"
		Vector2(0, 1): animation += "Down"
		Vector2(0, -1): animation += "Up"
			
	animation_player.play(animation)

func show_defeat() -> void:
	EventBus.defeat.emit()
	
func attack_take_damage_change() -> void:
	if Input.get_vector("move_left", "move_right", "move_up", "move_down"):
		switch_state(States.MOVE)
	else:
		switch_state(States.IDLE)

func _on_hp_component_health_changed(new_value: float, type: HPComponent.HEALTH_CHANGED_TYPE) -> void:
	match type:
		HPComponent.HEALTH_CHANGED_TYPE.HEAL:
			animated_sprite.self_modulate = Color(0, 0.8, 0, 0.75)
			healing_particles.emitting = true
			
			if heal_tween and heal_tween.is_valid():
				heal_tween.kill()
				
			heal_tween = create_tween()
			heal_tween.tween_property(animated_sprite, "self_modulate", Color.WHITE, 0.5)
		HPComponent.HEALTH_CHANGED_TYPE.TAKE_DAMAGE:
			if new_value > 0:
				if current_state != States.ATTACK:
					switch_state(States.TAKE_DAMAGE)
				else:
					animated_sprite.self_modulate = Color(0.7, 0, 0, 0.75)
			else:
				switch_state(States.DEAD)

func _on_player_hp_mana_component_mana_changed(_new_value: int, type: PlayerHPManaComponent.MANA_CHANGED_TYPE) -> void:
	match type:
		PlayerHPManaComponent.MANA_CHANGED_TYPE.RESTORE:
			animated_sprite.self_modulate = Color(0.765, 0.137, 0.953, 1.0)
			mana_particles.emitting = true
			
			if mana_restore_tween and mana_restore_tween.is_valid():
				mana_restore_tween.kill()
				
			mana_restore_tween = create_tween()
			mana_restore_tween.tween_property(animated_sprite, "self_modulate", Color.WHITE, 0.5)

func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox") and area is Hurtbox:
		area.take_damage(damage)
