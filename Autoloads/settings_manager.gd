extends Node

const SETTINGS_PATH: String = "user://settings.cfg"
var config: ConfigFile = ConfigFile.new()

var master_bus: int
var music_bus: int
var sfx_bus: int

func _ready() -> void:
	master_bus = AudioServer.get_bus_index("Master")
	music_bus = AudioServer.get_bus_index("Music")
	sfx_bus = AudioServer.get_bus_index("SFX")
	
	load_and_apply()
	
#Функція для читтання фалу налаштувань та застосування до мікшерів та вікна
func load_and_apply() -> void:
	if config.load(SETTINGS_PATH) != OK:
		return
		
	var master_vol: float = config.get_value("Audio", "master", 1.0)
	var music_vol: float = config.get_value("Audio", "music", 1.0)
	var sfx_vol: float = config.get_value("Audio", "sfx", 1.0)
	var is_fullscreen: bool = config.get_value("Video", "fullscreen", false)
	
	AudioServer.set_bus_volume_db(master_bus, linear_to_db(master_vol))
	AudioServer.set_bus_volume_db(music_bus, linear_to_db(music_vol))
	AudioServer.set_bus_volume_db(sfx_bus, linear_to_db(sfx_vol))
	
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		
func save_settings(master_val: float, music_val: float, sfx_val: float, fullscreen_val: bool) -> void:
	config.set_value("Audio", "master", master_val)
	config.set_value("Audio", "music", music_val)
	config.set_value("Audio", "sfx", sfx_val)
	config.set_value("Video", "fullscreen", fullscreen_val)
	config.save(SETTINGS_PATH)
