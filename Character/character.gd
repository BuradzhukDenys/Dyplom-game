extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hp_component: HPComponent = $HPComponent
@onready var take_damage_timer: Timer = $TakeDamageTimer
@onready var attack_cooldown_timer: Timer = $AttackCooldownTimer

const SPEED: float = 300.0

var last_direction: Vector2 = Vector2.DOWN
var can_attack: bool = true

enum States
{
	IDLE,
	MOVE,
	ATTACK,
	TAKE_DAMAGE,
	DEAD
}

var current_state: States = States.IDLE

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("attack") and can_attack and current_state in [States.IDLE, States.MOVE]:
		switch_state(States.ATTACK)

func _physics_process(_delta: float) -> void:
	process_state(_delta)
	move_and_slide()
	PlayerData.player_position = global_position

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
			
			$HitboxHurtboxComponent/Hitbox/CollisionShape2D.set_deferred("disabled", true)
			$HitboxHurtboxComponent/Hurtbox/CollisionShape2D.set_deferred("disabled", true)

func _exit_state(state: States) -> void:
	match state:
		States.IDLE:
			pass
		States.MOVE:
			pass
		States.ATTACK:
			animated_sprite.self_modulate = Color(1, 1, 1, 1)
		States.TAKE_DAMAGE:
			pass
		States.DEAD:
			pass

func switch_state(new_state: States) -> void:
	if current_state == new_state:
		return
		
	_exit_state(current_state)
	
	current_state = new_state
	
	_enter_state(current_state)

func process_state(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	match current_state:
		States.IDLE:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
			if direction:
				switch_state(States.MOVE)
		States.MOVE:
			velocity = direction * SPEED
			if direction:
				if abs(direction.x) > abs(direction.y):
					last_direction = Vector2(signf(direction.x), 0)
				else:
					last_direction = Vector2(0, signf(direction.y))
				play_animation_directionaly("Move")
			else:
				switch_state(States.IDLE)
		States.ATTACK:
			velocity = velocity.move_toward(Vector2.ZERO, SPEED)
		States.TAKE_DAMAGE:
			velocity = direction * SPEED
		States.DEAD:
			velocity = velocity.move_toward(Vector2.ZERO, SPEED)

func play_animation_directionaly(anim_name: String) -> void:
	var animation: String = anim_name
	match last_direction:
		Vector2(1, 0): animation += "Right"
		Vector2(-1, 0): animation += "Left"
		Vector2(0, 1): animation += "Down"
		Vector2(0, -1): animation += "Up"
			
	animated_sprite.play(animation)

func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation.containsn("Attack") or animated_sprite.animation.containsn("TakeDamage"):
		if Input.get_vector("move_left", "move_right", "move_up", "move_down"):
			switch_state(States.MOVE)
		else:
			switch_state(States.IDLE)
	elif animated_sprite.animation.containsn("Die"):
		get_tree().change_scene_to_file("res://MainMenu/main_menu.tscn")

func _on_hp_component_health_changed(new_value: float) -> void:
	if hp_component.is_invincible:
		return
		
	if new_value > 0:
		hp_component.is_invincible = true
		take_damage_timer.start()
		
		if current_state != States.ATTACK:
			switch_state(States.TAKE_DAMAGE)
		else:
			animated_sprite.self_modulate = Color(0.7, 0, 0, 0.75)
	else:
		switch_state(States.DEAD)

func _on_take_damage_timer_timeout() -> void:
	hp_component.is_invincible = false

func _on_attack_cooldown_timer_timeout() -> void:
	can_attack = true
