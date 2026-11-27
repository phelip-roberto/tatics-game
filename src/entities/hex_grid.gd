
extends Node2D
class_name HexGrid

const GRID_WIDTH: int = 12
const GRID_HEIGHT: int = 12
const HEX_SIZE: float = 28.0
const GRID_MARGIN: float = 24.0

const CELL_COLOR := Color("#303b46")
const CELL_BORDER_COLOR := Color("#8295a8")
const REACHABLE_COLOR := Color("#426b68")

var unit: TacticalUnit
var units_layer: Node2D
var unit_selected: bool = false


func _ready() -> void:
	print("Battle: _ready iniciado")
	print("Viewport: ", get_viewport_rect().size)

	center_grid()
	print("Posição da grade: ", position)
	print("Escala da grade: ", scale)

	queue_redraw()

func configure_test_unit(test_unit: TacticalUnit, unit_layer: Node2D) -> void:
	unit = test_unit
	units_layer = unit_layer


func cell_to_units_local(cell: Vector2i) -> Vector2:
	return units_layer.to_local(to_global(cell_to_local(cell)))


func cell_to_local(cell: Vector2i) -> Vector2:
	var col := float(cell.x)
	var row := float(cell.y)

	return Vector2(
		HEX_SIZE * 1.5 * col,
		HEX_SIZE * sqrt(3.0) * (row + col * 0.5)
	)


func get_hex_points(center: Vector2) -> PackedVector2Array:
	var points := PackedVector2Array()

	for i in range(6):
		var angle := deg_to_rad(60.0 * i)

		points.append(
			center + Vector2(
				HEX_SIZE * cos(angle),
				HEX_SIZE * sin(angle)
			)
		)

	return points


func get_grid_bounds() -> Rect2:
	var min_x := INF
	var min_y := INF
	var max_x := -INF
	var max_y := -INF

	for row in range(GRID_HEIGHT):
		for col in range(GRID_WIDTH):
			var center := cell_to_local(Vector2i(col, row))

			for point in get_hex_points(center):
				min_x = minf(min_x, point.x)
				min_y = minf(min_y, point.y)
				max_x = maxf(max_x, point.x)
				max_y = maxf(max_y, point.y)

	return Rect2(
		Vector2(min_x, min_y),
		Vector2(max_x - min_x, max_y - min_y)
	)


func center_grid() -> void:
	var bounds := get_grid_bounds()
	var viewport_size := get_viewport_rect().size
	var available_size := viewport_size - Vector2(
		GRID_MARGIN * 2.0,
		GRID_MARGIN * 2.0
	)

	var scale_factor := minf(
		1.0,
		minf(
			available_size.x / bounds.size.x,
			available_size.y / bounds.size.y
		)
	)

	scale = Vector2.ONE * scale_factor

	position = viewport_size * 0.5 - (
		bounds.position + bounds.size * 0.5
	) * scale_factor


func hex_distance(a: Vector2i, b: Vector2i) -> int:
	var dq: int = a.x - b.x
	var dr: int = a.y - b.y

	return int(
		(abs(dq) + abs(dr) + abs(dq + dr)) / 2
	)


func is_inside_grid(cell: Vector2i) -> bool:
	return (
		cell.x >= 0
		and cell.x < GRID_WIDTH
		and cell.y >= 0
		and cell.y < GRID_HEIGHT
	)


func is_reachable(cell: Vector2i) -> bool:
	return (
		is_inside_grid(cell)
		and cell != unit.grid_cell
		and hex_distance(unit.grid_cell, cell)
			<= unit.movement_range
	)


func _draw() -> void:
	for row in range(GRID_HEIGHT):
		for col in range(GRID_WIDTH):
			var cell := Vector2i(col, row)
			var points := get_hex_points(cell_to_local(cell))

			var fill_color := CELL_COLOR

			if unit_selected and is_reachable(cell):
				fill_color = REACHABLE_COLOR

			draw_colored_polygon(points, fill_color)

			var outline := points.duplicate()
			outline.append(points[0])

			draw_polyline(
				outline,
				CELL_BORDER_COLOR,
				1.5,
				true
			)


func get_cell_at_position(local_mouse: Vector2) -> Vector2i:
	for row in range(GRID_HEIGHT):
		for col in range(GRID_WIDTH):
			var cell := Vector2i(col, row)
			var polygon := get_hex_points(cell_to_local(cell))

			if Geometry2D.is_point_in_polygon(
				local_mouse,
				polygon
			):
				return cell

	return Vector2i(-1, -1)



func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return

	if (
		event.button_index != MOUSE_BUTTON_LEFT
		or not event.pressed
	):
		return

	handle_click_at_global_position(get_global_mouse_position())


func handle_click_at_global_position(global_mouse_position: Vector2) -> void:
	var mouse_position: Vector2 = to_local(global_mouse_position)

	# Clique na unidade: seleciona ou deseleciona.
	var unit_center := cell_to_local(unit.grid_cell)

	if mouse_position.distance_to(unit_center) <= (
		TacticalUnit.UNIT_RADIUS + 5.0
	):
		unit_selected = not unit_selected
		unit.set_selected(unit_selected)

		if unit_selected:
			print("Unidade selecionada: ", unit.unit_name)
		else:
			print("Unidade deselecionada.")

		queue_redraw()
		return

	# Sem unidade selecionada, não há movimentação.
	if not unit_selected:
		return

	var target_cell := get_cell_at_position(mouse_position)

	if is_reachable(target_cell):
		unit.set_grid_cell(
			target_cell,
			cell_to_units_local(target_cell)
		)

		print("Unidade movimentada para: ", target_cell)
		queue_redraw()
		return

	# Primeiro clique inválido: registra a posição.
	# Segundo clique inválido: deseleciona.
	if not has_meta("last_invalid_click"):
		set_meta("last_invalid_click", true)
		return

	remove_meta("last_invalid_click")
	unit_selected = false
	unit.set_selected(false)

	print("Unidade deselecionada após dois cliques inválidos.")
	queue_redraw()
