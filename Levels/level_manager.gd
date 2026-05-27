extends Node
class_name LevelManager

signal spawn_enemy(enemy: Enemy, spawn_method: String, group_angle: float)
signal all_groups_spawned
signal all_waves_spawned

@export var level_resource: LevelResource
var group_spawned: int = 0

func _ready() -> void:
	start_level()

func start_level() -> void:
	for wave: WaveResource in level_resource.waves:
		EventBus.wave_changed.emit("Wave %d" % (level_resource.waves.find(wave) + 1))
		
		for group: GroupResource in wave.wave_enemies:
			group_spawned += 1
			spawn_group(group)
		
		if group_spawned > 0:
			await all_groups_spawned
		
		if wave.wave_offset > 0.0:
			await get_tree().create_timer(wave.wave_offset, false).timeout
		
	all_waves_spawned.emit()

func spawn_group(group: GroupResource) -> void:
	if group.time_offset > 0.0:
		await get_tree().create_timer(group.time_offset, false).timeout
		
	var group_angle: float = TAU * randf()
		
	for i in range(group.count):
		if not group.enemy_scene: 
			continue
			
		var enemy: Enemy = group.enemy_scene.instantiate()
		spawn_enemy.emit(enemy, group.spawn_method, group_angle)
		
		if group.time_interval > 0.0:
			await get_tree().create_timer(group.time_interval, false).timeout
	
	group_spawned -= 1
	
	if group_spawned <= 0:
		all_groups_spawned.emit()
