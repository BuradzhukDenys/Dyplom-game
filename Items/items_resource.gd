extends Resource
class_name ItemData

@export var texture: Texture2D = AtlasTexture.new()
@export var cost: int
@export var item_name: String = ""

func get_tooltip_name_cost() -> String:
	#Повертаємо рядок з характеристиками назви та вартості предмета
	var lines_name: PackedStringArray = PackedStringArray()
	
	lines_name.append("[b]%s[/b]" % item_name)
	lines_name.append("[color=gold]%d gold[/color]\n[hr]" % cost)
	return "\n".join(lines_name)

func get_tooltip_stats() -> String:
	return ""
