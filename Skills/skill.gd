extends Area2D
class_name Skill

@onready var animation: AnimationPlayer = $AnimationPlayer
@export var hitbox: Area2D

var direction: Vector2 = Vector2.DOWN
var damage: float = 0

func _ready() -> void:
	hitbox.area_entered.connect(_on_hitbox_entered)
	match direction:
		Vector2.DOWN:
			rotation = PI / 2
		Vector2.UP:
			rotation = -PI / 2
		Vector2.LEFT:
			animation.play("left")

func setup(new_direction: Vector2, new_damage: float) -> void:
	direction = new_direction
	damage = new_damage

func _on_hitbox_entered(area: Hurtbox) -> void:
	if area.is_in_group("enemy_hurtbox") and area is Hurtbox:
		area.take_damage(damage)
