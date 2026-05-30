extends CanvasLayer
class_name StatsUI

@onready var stats: RichTextLabel = $MarginContainer/CenterContainer/PanelContainer/VBoxContainer/VBoxContainer/RichTextLabel

func _ready() -> void:
	hide()

func show_stats() -> void:
	get_tree().paused = true
	show()
	
	var lines: PackedStringArray = stats.text.split("\n")
	
	for i in lines.size():
		var stat_text: String = ""
		if lines[i].containsn("Max health"):
			stat_text = "[color=green]Max health - " + str(PlayerData.max_health) + "[/color]"
		elif lines[i].containsn("Max mana"):
			stat_text = "[color=purple]Max mana - " + str(PlayerData.max_mana) + "[/color]"
		elif lines[i].containsn("Damage"):
			stat_text = "[color=red]Damage - " + str(PlayerData.damage) + "[/color]"
		elif lines[i].containsn("Speed"):
			stat_text = "[color=blue]Speed - " + str(PlayerData.speed) + "[/color]"
			
		lines[i] = stat_text
			
	stats.text = "\n".join(lines)

func _on_close_pressed() -> void:
	hide()
	
	if EventBus.game_end:
		return
	get_tree().paused = false
