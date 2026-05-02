extends Node

const PLAYER_RADIUS_SPAWN_ENEMIES: float = 730.0
var player_position: Vector2 = Vector2.ZERO
var player_dead: bool = false

func reset_data() -> void:
	player_dead = false
	player_position = Vector2.ZERO
