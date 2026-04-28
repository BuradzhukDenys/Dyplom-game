extends OptionButton

var resolutions: Dictionary = {
	"3840x2160": Vector2i(3840, 2160),
	"2560x1440": Vector2i(2560, 1440),
	"1920x1080": Vector2i(1920, 1080),
	"1280x720": Vector2i(1280, 720),
	"1024x768": Vector2i(1024, 768),
	"960x540": Vector2i(960, 540),
	"800x600": Vector2i(800, 600),
	"640x360": Vector2i(640, 360)
}

func _ready() -> void:
	clear()
	var display_size: Vector2i = DisplayServer.screen_get_size()
	for resolution in resolutions:
		if resolutions[resolution] <= display_size:
			add_item(resolution)
			

func _on_item_selected(index: int) -> void:
	var new_size: Array = get_item_text(index).split("x")
	var new_res: Vector2i = Vector2i.ZERO
	new_res.x = new_size[0].to_int()
	new_res.y = new_size[1].to_int()
	var window: Window = get_window()
	
	if window.mode == Window.MODE_WINDOWED:
		window.size = new_res
		var screen_center = DisplayServer.screen_get_size() / 2.0
		window.position = screen_center - (new_res / 2.0)
