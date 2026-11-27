extends SceneTree

const HexGridScript = preload("res://scripts/grid/hex_grid.gd")

var _failure_count: int = 0


func _initialize() -> void:
	_test_hex_distance()
	_test_grid_bounds()
	_finish()


func _test_hex_distance() -> void:
	var grid: Variant = HexGridScript.new()
	_check(grid.hex_distance(Vector2i(2, 2), Vector2i(2, 2)) == 0, "same cell has distance zero")
	_check(grid.hex_distance(Vector2i(2, 2), Vector2i(3, 2)) == 1, "adjacent cell has distance one")
	_check(grid.hex_distance(Vector2i(2, 2), Vector2i(4, 4)) == 4, "distance works across multiple axes")
	grid.free()


func _test_grid_bounds() -> void:
	var grid: Variant = HexGridScript.new()
	_check(grid.is_inside_grid(Vector2i.ZERO), "top-left cell is inside the grid")
	_check(grid.is_inside_grid(Vector2i(11, 11)), "bottom-right cell is inside the grid")
	_check(not grid.is_inside_grid(Vector2i(-1, 0)), "negative column is outside the grid")
	_check(not grid.is_inside_grid(Vector2i(12, 0)), "column past width is outside the grid")
	grid.free()


func _check(condition: bool, description: String) -> void:
	if condition:
		print("PASS: ", description)
		return

	_failure_count += 1
	push_error("FAIL: " + description)


func _finish() -> void:
	if _failure_count > 0:
		push_error("Test run failed with %d failure(s)." % _failure_count)
		quit(1)
		return

	print("All tests passed.")
	quit(0)
