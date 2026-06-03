extends Skill

var entered_enemy_hurtboxes: Array[Area2D] = []

func _ready() -> void:
	super._ready()

func _on_hitbox_entered(area: Area2D) -> void:
	if entered_enemy_hurtboxes.has(area):
		return
		
	if area.is_in_group("enemy_hurtbox") and area is Hurtbox:
		entered_enemy_hurtboxes.append(area)
		
		area.tree_exited.connect(func(): entered_enemy_hurtboxes.erase(area))
		
		super._on_hitbox_entered(area)
