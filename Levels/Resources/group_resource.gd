extends Resource
class_name GroupResource

@export var enemy_scene: PackedScene
@export var count: int
@export var time_interval: float
@export var time_offset: float
@export_enum("Arround", "Point") var spawn_method: String = "Arround"
