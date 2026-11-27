
extends Node2D
class_name TacticalUnit

const UNIT_RADIUS: float = 12.0

@export var unit_name: String = "Aliado"
@export var max_hp: int = 100
@export var movement_range: int = 3
@export var unit_color: Color = Color("#4da6ff")

var current_hp: int = 100
var grid_cell: Vector2i = Vector2i.ZERO
var is_selected: bool = false


func _ready() -> void:
	current_hp = max_hp
	queue_redraw()


func set_grid_cell(cell: Vector2i, world_position: Vector2) -> void:
	grid_cell = cell
	position = world_position


func set_selected(value: bool) -> void:
	is_selected = value
	queue_redraw()


func _draw() -> void:
	draw_circle(Vector2.ZERO, UNIT_RADIUS, unit_color)

	if is_selected:
		draw_arc(
			Vector2.ZERO,
			UNIT_RADIUS + 4.0,
			0.0,
			TAU,
			32,
			Color("#e6b450"),
			2.0
		)
