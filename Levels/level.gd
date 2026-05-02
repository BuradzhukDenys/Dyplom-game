extends Node2D

@export var slime_scene: PackedScene
@onready var enemies: Node2D = $Enemies

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_0 and event.is_pressed():
			_on_spawn_enemies_timer_timeout()

func _on_spawn_enemies_timer_timeout() -> void:
	var slime: Area2D = slime_scene.instantiate()
	slime.global_position = random_spawn_pos()
	enemies.add_child(slime)

func random_spawn_pos() -> Vector2:
	var test_position: Vector2
	var is_valid: bool = false
	var attempts: int = 0
	
	while not is_valid and attempts < 50:
		var spawn_pos: Vector2 = Vector2.from_angle(TAU * randf()) * PlayerData.PLAYER_RADIUS_SPAWN_ENEMIES
		test_position = PlayerData.player_position + spawn_pos
		
		if test_position.x < 1970 or test_position.x > -1970 or test_position.y < 960 or test_position.y > -960:
			is_valid = true
			
		attempts += 1
		
	test_position.x = clamp(test_position.x, -1970, 1970)
	test_position.y = clamp(test_position.y, -1970, 1970)
	
	return test_position
