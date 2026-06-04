extends Interface
class_name StatsUI

@onready var stats: RichTextLabel = $MarginContainer/CenterContainer/PanelContainer/VBoxContainer/VBoxContainer/RichTextLabel

func _ready() -> void:
	hide()

func open() -> void:
	#Генеруємо характеристики в залежності від характеристик гравця
	var lines: PackedStringArray = stats.text.split("\n")
	
	for i in lines.size():
		var stat_text: String = ""
		if lines[i].containsn("Max health"):
			var flat_bonus: int = round(PlayerData.max_health - PlayerData.base_health)
			
			var bonus_str: String = " (%+d)" % flat_bonus if flat_bonus != 0 else ""
			
			stat_text = "[color=green]Max health: " + str(PlayerData.max_health) + bonus_str + "[/color]"
		elif lines[i].containsn("Health restore"):
			var restore_bonus:float = PlayerData.health_restore - PlayerData.base_health_restore
			var bonus_str: String = " (%+.1f)" % restore_bonus if abs(restore_bonus) > 0.001 else ""
			stat_text = "[color=lightgreen]Health restore: %.1f%s[/color]" % [PlayerData.health_restore, bonus_str]
		elif lines[i].containsn("Max mana"):
			var flat_bonus: int = round(PlayerData.max_mana - PlayerData.base_mana)
			
			var bonus_str: String = " (%+d)" % flat_bonus if flat_bonus != 0 else ""
			stat_text = "[color=purple]Max mana: " + str(PlayerData.max_mana) + bonus_str + "[/color]"
		elif lines[i].containsn("Mana restore"):
			var restore_bonus:float = PlayerData.mana_restore - PlayerData.base_mana_restore
			var bonus_str: String = " (%+.1f)" % restore_bonus if abs(restore_bonus) > 0.001 else ""
			stat_text = "[color=magenta]Mana restore: %.1f%s[/color]" % [PlayerData.mana_restore, bonus_str]
		elif lines[i].containsn("Damage"):
			var percent: int = round((PlayerData.bonus_percent_damage - 1.0) * 100.0)
			var flat_bonus: int = round((PlayerData.damage / PlayerData.bonus_percent_damage) - PlayerData.base_damage)
			var bonus_str: String = ""
			
			if flat_bonus != 0 and percent != 0:
				bonus_str = " (%+d, %+d%%)" % [flat_bonus, percent]
			elif flat_bonus != 0:
				bonus_str = " (%+d)" % flat_bonus
			elif percent != 0:
				bonus_str = " (%+d%%)" % percent
			
			stat_text = "[color=red]Damage: " + str(round(PlayerData.damage)) + bonus_str + "[/color]"
		elif lines[i].containsn("Speed"):
			var percent: int = round((PlayerData.bonus_percent_speed - 1.0) * 100.0)
			var flat_bonus: int = round((PlayerData.speed / PlayerData.bonus_percent_speed) - PlayerData.base_speed)
			var bonus_str: String = ""
			
			if flat_bonus != 0 and percent != 0:
				bonus_str = " (%+d, %+d%%)" % [flat_bonus, percent]
			elif flat_bonus != 0:
				bonus_str = " (%+d)" % flat_bonus
			elif percent != 0:
				bonus_str = " (%+d%%)" % percent
			
			stat_text = "[color=lightblue]Speed: " + str(round(PlayerData.speed)) + bonus_str + "[/color]"
		elif lines[i].containsn("Skill"):
			var percent: int = round((PlayerData.bonus_percent_skill_damage - 1.0) * 100.0)
			var flat_bonus: float
			
			if PlayerData.skill_damage < 0:
				flat_bonus = PlayerData.skill_damage - PlayerData.base_skill_damage
			else:
				flat_bonus = (PlayerData.skill_damage / PlayerData.bonus_percent_skill_damage) - PlayerData.base_skill_damage
			
			var bonuses: PackedStringArray = []
			
			if round(flat_bonus) != 0:
				bonuses.append("%+d" % round(flat_bonus))
			if percent != 0:
				bonuses.append("%+d%%" % percent)
			
			if bonuses.is_empty():
				stat_text = "[color=yellow]Skill amplification: 0[/color]"
			else:
				stat_text = "[color=yellow]Skill amplification: %.1f (%s)[/color]" % [PlayerData.skill_damage, ", ".join(bonuses)]
			
		if stat_text != "":
			lines[i] = stat_text
			
	stats.text = "\n".join(lines)
	super.open()

func _on_close_pressed() -> void:
	close()
	
	if EventBus.game_end:
		get_tree().paused = true
