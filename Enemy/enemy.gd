extends CharacterBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $HitboxHurtboxComponent/Hitbox

const SPEED: float = 140.0
const DAMAGE: float = 10.0

var is_touching_player: bool = false

func _physics_process(delta: float) -> void:
	var target_direction: Vector2 = global_position.direction_to(PlayerData.player_position)
	velocity = SPEED * target_direction
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
	
	try_attack()
	if distance_to_player > stop_distance:
		move_and_slide()

func attack_player(area: Area2D) -> void:
	area.get_hp_component().take_damage(DAMAGE)
	
func try_attack() -> void:
	if is_touching_player:
		var all_areas: Array[Area2D] = hitbox.get_overlapping_areas()
		if not all_areas.is_empty():
			attack_player(all_areas[0])

func _on_hitbox_area_entered(area: Area2D) -> void:
	is_touching_player = true

func _on_hitbox_area_exited(area: Area2D) -> void:
	is_touching_player = false
