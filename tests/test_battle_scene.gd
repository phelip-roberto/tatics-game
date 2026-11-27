extends SceneTree

const BATTLE_SCENE: PackedScene = preload("res://scenes/battle/battle.tscn")
const POSITION_TOLERANCE: float = 0.01

var _failure_count: int = 0


func _initialize() -> void:
	call_deferred("_run_scene_checks")


func _run_scene_checks() -> void:
	var battle: Node2D = BATTLE_SCENE.instantiate() as Node2D
	root.add_child(battle)
	await process_frame

	var units_layer: Node2D = battle.get_node("Units") as Node2D
	var grid: HexGrid = battle.get_node("HexGrid") as HexGrid
	var unit: TacticalUnit = units_layer.get_node("Unit") as TacticalUnit
	var expected_global_position: Vector2 = grid.to_global(
		grid.cell_to_local(unit.grid_cell)
	)

	_check(unit.get_parent() == units_layer, "test unit is under the Units layer")
	_check(
		unit.global_position.distance_to(expected_global_position) <= POSITION_TOLERANCE,
		"unit global position matches its grid cell after sibling transform conversion"
	)
	_check(
		unit.scale.is_equal_approx(grid.scale),
		"unit keeps the grid's scale when rendered in the sibling layer"
	)

	grid.handle_click_at_global_position(unit.global_position)
	_check(unit.is_selected, "unit can still be selected")

	var destination: Vector2i = Vector2i(3, 2)
	grid.handle_click_at_global_position(grid.to_global(grid.cell_to_local(destination)))
	var destination_global_position: Vector2 = grid.to_global(
		grid.cell_to_local(destination)
	)
	_check(unit.grid_cell == destination, "selected unit can still move to a reachable cell")
	_check(
		unit.global_position.distance_to(destination_global_position) <= POSITION_TOLERANCE,
		"moved unit remains aligned to the destination cell"
	)

	battle.queue_free()
	await process_frame
	_finish()


func _check(condition: bool, description: String) -> void:
	if condition:
		print("PASS: ", description)
		return

	_failure_count += 1
	push_error("FAIL: " + description)


func _finish() -> void:
	if _failure_count > 0:
		push_error("Battle scene checks failed with %d failure(s)." % _failure_count)
		quit(1)
		return

	print("All battle scene checks passed.")
	quit(0)
