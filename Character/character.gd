extends CharacterBody2D

#region nodes
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hp_mana_component: PlayerHPManaComponent = $PlayerHPManaComponent
@onready var take_damage_timer: Timer = $TakeDamageTimer
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer
@onready var hitbox: Area2D = $HitboxHurtboxComponent/Hitbox
@onready var hitbox_collision: CollisionShape2D = $HitboxHurtboxComponent/Hitbox/CollisionShape2D
@onready var hurtbox_collision: CollisionShape2D = $HitboxHurtboxComponent/Hurtbox/CollisionShape2D
@onready var healing_particles: GPUParticles2D = $ParticleManager/HealParticles
@onready var mana_particles: GPUParticles2D = $ParticleManager/ManaParticles
#endregion

#region values
@export var speed: float = 300.0
@export var damage: int = 10

var can_drink_healing_potion: bool = true
var can_drink_mana_potion: bool = true
const SPEED_WHEN_ATTACK: float = 0.5
const SPEED_TAKE_DAMAGE_SLOWNESS: float = 0.8
var last_direction: Vector2 = Vector2.DOWN
var can_attack: bool = true
#endregion

#region tweens
var mana_restor_tween: Tween
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
	EventBus.healing_potion_cooldown_finished.connect(func(): can_drink_healing_potion = true)
	EventBus.mana_potion_cooldown_finished.connect(func(): can_drink_mana_potion = true)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and can_attack and current_state in [States.IDLE, States.MOVE]:
		switch_state(States.ATTACK)
	if not PlayerData.player_dead:
		if event.is_action_pressed("drink_healing_potion") and can_drink_healing_potion and hp_mana_component.health < PlayerData.MAX_HEALTH:
			can_drink_healing_potion = false
			hp_mana_component.heal(PlayerData.healing_potion_heal)
			EventBus.healing_potion_drank.emit()
		if event.is_action_pressed("drink_mana_potion") and can_drink_mana_potion and hp_mana_component.mana < PlayerData.MAX_MANA:
			can_drink_mana_potion = false
			hp_mana_component.restore_mana(int(PlayerData.mana_potion_heal))
			EventBus.mana_potion_drank.emit()
		if event.is_action_pressed("skill1"):
			try_cast_skill_at_slot(1)

func _physics_process(_delta: float) -> void:
	process_state(_delta)
	move_and_slide()
	if global_position != PlayerData.player_position:
		PlayerData.player_position = global_position 

#region states_handle
func _enter_state(state: States) -> void:
	match state:
		States.IDLE:
			play_animation_directionaly("Idle")
		States.ATTACK:
			can_attack = false
			attack_cooldown_timer.start()
			play_animation_directionaly("Attack")
		States.TAKE_DAMAGE:
			play_animation_directionaly("TakeDamage")
		States.DEAD:
			PlayerData.player_dead = true
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

func return_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")
	
func attack_take_damage_change() -> void:
	if Input.get_vector("move_left", "move_right", "move_up", "move_down"):
		switch_state(States.MOVE)
	else:
		switch_state(States.IDLE)

func try_cast_skill_at_slot(slot: int) -> void:
	if not SkillsManager.is_skill_ready(slot): return
	
	var skill_data: SkillResource = SkillsManager.skills[slot]
	if hp_mana_component.mana < skill_data.mana_cost or hp_mana_component.mana <= 0:
		EventBus.no_mana.emit()
		return
		
	hp_mana_component.spend_mana(skill_data.mana_cost)
	SkillsManager.put_skill_on_cooldown(slot)
	EventBus.skill_casted.emit(slot, skill_data.cooldown)
	
	var skill: Area2D = skill_data.scene.instantiate()
	skill.setup(last_direction, skill_data.damage)
	get_tree().current_scene.add_child(skill)
	skill.global_position = global_position

func _on_hp_component_health_changed(new_value: float, type: HPComponent.HEALTH_CHANGED_TYPE) -> void:
	EventBus.player_health_changed.emit(new_value)
	
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
				hp_mana_component.is_invincible = true
				take_damage_timer.start()
				
				if current_state != States.ATTACK:
					switch_state(States.TAKE_DAMAGE)
				else:
					animated_sprite.self_modulate = Color(0.7, 0, 0, 0.75)
			else:
				switch_state(States.DEAD)

func _on_take_damage_timer_timeout() -> void:
	hp_mana_component.is_invincible = false

func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox"):
		area.get_hp_component().take_damage(damage)

func _on_player_hp_mana_component_mana_changed(new_value: int, type: PlayerHPManaComponent.MANA_CHANGED_TYPE) -> void:
	EventBus.player_mana_changed.emit(new_value)
	
	match type:
		PlayerHPManaComponent.MANA_CHANGED_TYPE.RESTORE:
			animated_sprite.self_modulate = Color(0.765, 0.137, 0.953, 1.0)
			mana_particles.emitting = true
			
			if mana_restor_tween and mana_restor_tween.is_valid():
				mana_restor_tween.kill()
				
			mana_restor_tween = create_tween()
			mana_restor_tween.tween_property(animated_sprite, "self_modulate", Color.WHITE, 0.5)
