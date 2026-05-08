extends Node2D

@export var slime_scene: PackedScene
@onready var enemies: Node2D = $Enemies

func _ready() -> void:
	PlayerData.reset_data()

func _input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_0 and event.is_pressed():
			_on_spawn_enemies_timer_timeout()
		elif event.keycode == KEY_1 and event.is_pressed():
			var slime: CharacterBody2D = slime_scene.instantiate()
			slime.global_position = get_global_mouse_position()
			enemies.add_child(slime)
			slime.enemy_dead.connect(_on_enenmy_dead.bind(slime))

func _on_spawn_enemies_timer_timeout() -> void:
	var slime: CharacterBody2D = slime_scene.instantiate()
	slime.global_position = random_spawn_pos()
	enemies.add_child(slime)
	slime.enemy_dead.connect(_on_enenmy_dead.bind(slime))

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
