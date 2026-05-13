extends Node

@export var node1: PanelContainer
@export var node2: PanelContainer
@export var line: Line2D

var node1_center: Vector2
var node2_center: Vector2
var node1_center_global: Vector2
var node2_center_global: Vector2
var points_steps: int

var selected_node: PanelContainer = null
var selected_node_center: Vector2

func _ready() -> void:
	if node1:
		node1.gui_input.connect(_on_panel_container_gui_input.bind(node1))
		node1_center_global = node1.global_position + (node1.size / 2.0)
		node1_center = node1.size / 2.0
		print("1")
	if node2:
		node2.gui_input.connect(_on_panel_container_gui_input.bind(node2))
		node2_center_global = node2.global_position + (node2.size / 2.0)
		node2_center = node2.size / 2.0
		print("2")
	if line:
		line.clear_points()
		line.add_point(node1_center_global, 0)
		line.add_point(Vector2(node1_center_global.x, node2_center_global.y), 1)
		line.add_point(node2_center_global, 2)

func _process(delta: float) -> void:
	if selected_node:
		selected_node.global_position = get_viewport().get_mouse_position() - selected_node_center
		node1_center_global = node1.global_position + (node1.size / 2.0)
		node2_center_global = node2.global_position + (node2.size / 2.0)
		
		line.set_point_position(0, node1_center_global)
		line.set_point_position(1, Vector2(node1_center_global.x, node2_center_global.y))
		line.set_point_position(2, node2_center_global)
func node_seleceted(node: PanelContainer) -> void:
	selected_node = node
	selected_node_center = node.size / 2.0
	node.modulate = Color.RED
	
func node_deseleceted(node: PanelContainer) -> void:
	selected_node = null
	selected_node_center = Vector2.ZERO
	node.modulate = Color.WHITE

func _on_panel_container_gui_input(event: InputEvent, node: PanelContainer) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			node_seleceted(node)
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.is_pressed():
			node_deseleceted(node)
