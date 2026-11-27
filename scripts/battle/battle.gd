extends Node2D

const UNIT_SCENE: PackedScene = preload("res://scenes/units/unit.tscn")
const TEST_UNIT_CELL: Vector2i = Vector2i(2, 2)

@onready var units_layer: Node2D = $Units
@onready var hex_grid: HexGrid = $HexGrid

var test_unit: TacticalUnit


func _ready() -> void:
	test_unit = UNIT_SCENE.instantiate() as TacticalUnit
	units_layer.add_child(test_unit)
	hex_grid.configure_test_unit(test_unit, units_layer)

	# Convert through global space because grid and units are sibling layers.
	test_unit.scale = hex_grid.scale
	test_unit.set_grid_cell(
		TEST_UNIT_CELL,
		hex_grid.cell_to_units_local(TEST_UNIT_CELL)
	)
