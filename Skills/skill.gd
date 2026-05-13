extends Area2D

@onready var animation: AnimationPlayer = $AnimationPlayer

var direction: Vector2 = Vector2.DOWN

func _ready() -> void:
	match direction:
		Vector2.DOWN:
			rotation = PI / 2
		Vector2.UP:
			rotation = -PI / 2
		Vector2.LEFT:
			animation.play("left")

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction
