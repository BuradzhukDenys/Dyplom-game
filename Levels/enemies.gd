extends Node2D

var all_waves_spawned: bool = false
var enemies_alive: int = 0

func spawn_at_position(enemy: Enemy, enemy_position: Vector2) -> void:
	enemy.global_position = enemy_position
	add_child(enemy)
	
	enemies_alive += 1
	
	enemy.enemy_dead.connect(_on_enenmy_dead.bind(enemy))

func point_spawn_pos(angle: float) -> Vector2:
	var jitter_angle: float = angle + randf_range(-0.15, 0.15)
	var test_position: Vector2
	
	var spawn_pos: Vector2 = Vector2.from_angle(jitter_angle) * PlayerData.PLAYER_RADIUS_SPAWN_ENEMIES
	test_position = PlayerData.player_position + spawn_pos

	test_position.x = clamp(test_position.x, -1970, 1970)
	test_position.y = clamp(test_position.y, -960, 960)
	
	return test_position

func random_spawn_pos() -> Vector2:
	var test_position: Vector2
	var is_valid: bool = false
	var attempts: int = 0
	
	while not is_valid and attempts < 50:
		var spawn_pos: Vector2 = Vector2.from_angle(TAU * randf()) * PlayerData.PLAYER_RADIUS_SPAWN_ENEMIES
		test_position = PlayerData.player_position + spawn_pos
		
		if test_position.x < 1970 and test_position.x > -1970 and test_position.y < 960 and test_position.y > -960:
			is_valid = true
			
		attempts += 1
		
	test_position.x = clamp(test_position.x, -1970, 1970)
	test_position.y = clamp(test_position.y, -960, 960)
	
	return test_position

func _on_enenmy_dead(enemy: CharacterBody2D) -> void:
	enemy.queue_free()
	
	enemies_alive -= 1
	
	check_victory()

func _on_level_manager_spawn_enemy(enemy: Enemy, spawn_method: String, group_angle: float) -> void:
	match spawn_method:
		"Arround":
			spawn_at_position(enemy, random_spawn_pos())
		"Point":
			spawn_at_position(enemy, point_spawn_pos(group_angle))

func _on_level_manager_all_waves_spawned() -> void:
	all_waves_spawned = true
	
	check_victory()

func check_victory() -> void:
	if all_waves_spawned and enemies_alive <= 0:
		EventBus.game_end = true
		EventBus.victory.emit()
