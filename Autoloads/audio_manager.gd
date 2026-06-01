extends Node

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var ui_player: AudioStreamPlayer = $UIPlayer
@onready var error_player: AudioStreamPlayer = $ErrorPlayer
@onready var fanfare_player: AudioStreamPlayer = $FanfarePlayer

@export var main_menu_music: AudioStream
@export var level_music: AudioStream

@export var victory_sound: AudioStream
@export var defeat_sound: AudioStream

@export var click_sound: AudioStream
@export var buy_sound: AudioStream
@export var error_sound: AudioStream

func _ready() -> void:
	get_tree().node_added.connect(_on_node_added)
	
	_setup_existing_nodes(get_tree().root)

func _setup_existing_nodes(node: Node) -> void:
	_on_node_added(node)
	
	for child in node.get_children():
		_setup_existing_nodes(child)

func play_music(new_track: AudioStream) -> void:
	if music_player.stream == new_track and music_player.playing:
		return
		
	music_player.stream = new_track
	music_player.play()
	
func stop_music() -> void:
	music_player.stop()
	
func play_sfx(sound: AudioStream) -> void:
	if sound:
		ui_player.stream = sound
		ui_player.play()
	
func play_ui_click() -> void:
	play_sfx(click_sound)
	
func stop_sfx() -> void:
	ui_player.stop()
	
func stop_fanfare() -> void:
	fanfare_player.stop()
	
func play_fanfare(fanfare_sound: AudioStream) -> void:
	if fanfare_sound:
		music_player.stop()
		fanfare_player.stream = fanfare_sound
		fanfare_player.play()
	
func play_victory_fanfare() -> void:
	play_fanfare(victory_sound)
	
func play_defeat_fanfare() -> void:
	play_fanfare(defeat_sound)
	
func play_error() -> void:
	if error_sound:
		error_player.stream = error_sound
		error_player.play()
	
func _on_node_added(node: Node) -> void:
	if node is BaseButton:
		node.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		if not node.is_in_group("ignore_click"):
			if not node.pressed.is_connected(play_ui_click):
				node.pressed.connect(play_ui_click)
