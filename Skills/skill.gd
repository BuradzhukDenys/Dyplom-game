extends Area2D
class_name Skill

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var hit_sound: AudioStream

var direction: Vector2 = Vector2.RIGHT
var damage: float = 0

func _ready() -> void:
	AudioManager.play_spatial_sound(hit_sound, global_position)
	area_entered.connect(_on_hitbox_entered)
	
	animated_sprite.flip_h = false
	match direction:
		Vector2.DOWN:
			rotation = PI / 2
		Vector2.UP:
			rotation = -PI / 2
		Vector2.LEFT:
			if animation.has_animation("left"):
				animation.play("left")
				return
				
			animated_sprite.flip_h = true

func setup(new_direction: Vector2, new_damage: float) -> void:
	direction = new_direction
	
	var amplification_base: float = new_damage * PlayerData.bonus_percent_skill_damage
	
	damage = amplification_base + PlayerData.skill_damage
	
	if damage < 0:
		damage = 0

func _on_hitbox_entered(area: Area2D) -> void:
	if area.is_in_group("enemy_hurtbox") and area is Hurtbox:
		area.take_damage(damage)

func delete() -> void:
	queue_free()
