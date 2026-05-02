extends Area2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: Area2D = $HitboxHurtboxComponent/Hurtbox

const SPEED: float = 140.0
const DAMAGE: float = 10.0
const ATTACK_CHARACTER_COOLDOWN: float = 1.0

var attack_character_cooldown_timer: Timer = Timer.new()
var can_attack: bool = true
var is_touching_player: bool = false

func _ready() -> void:
	attack_character_cooldown_timer.timeout.connect(_on_can_attack)
	add_child(attack_character_cooldown_timer)

func _physics_process(delta: float) -> void:
	var target_direction: Vector2 = global_position.direction_to(PlayerData.player_position)
	var velocity: Vector2 = SPEED * target_direction * delta
	var animation_direction: float = Vector2.RIGHT.dot(target_direction)
	
	if animation_direction <= 1.0 and animation_direction > 0.7:
		animated_sprite.play("JumpLeftRight")
		animated_sprite.flip_h = false
	elif animation_direction >= -1.0 and animation_direction < -0.7:
		animated_sprite.play("JumpLeftRight")
		animated_sprite.flip_h = true
	elif animation_direction <= 0.7 and animation_direction >= -0.7 and target_direction.y <= 0:
		animated_sprite.play("JumpUp")
		animated_sprite.flip_h = false
	elif animation_direction <= 0.7 and animation_direction >= -0.7 and target_direction.y > 0:
		animated_sprite.play("JumpDown")
		animated_sprite.flip_h = false
	
	var distance_to_player: float = global_position.distance_to(PlayerData.player_position)
	var stop_distance: float = 2.0
	
	if distance_to_player > stop_distance:
		global_position += velocity
	else:
		pass

func attack_player(area: Area2D) -> void:
	if PlayerData.player_dead:
		return
	
	area.get_hp_component().take_damage(DAMAGE)
	can_attack = false
	attack_character_cooldown_timer.start(ATTACK_CHARACTER_COOLDOWN)
	

func _on_can_attack() -> void:
	can_attack = true
	
	if is_touching_player:
		var all_areas: Array[Area2D] = hurtbox.get_overlapping_areas()
		for area: Area2D in all_areas:
			if area.is_in_group("player_hitbox"):
				attack_player(area)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("player_hitbox"):
		is_touching_player = true
		
		if can_attack:
			attack_player(area)

func _on_hurtbox_area_exited(area: Area2D) -> void:
	if area.is_in_group("player_hitbox"):
		is_touching_player = false
