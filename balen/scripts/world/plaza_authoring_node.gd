@tool
extends Node2D
class_name PlazaAuthoringNode

enum AuthoringKind {
	ROAD,
	SIDEWALK,
	FOUNDATION,
	BUILDING,
	TENT,
	ROUTE,
	SPAWN,
	CROWD,
	BANNER,
	COMBAT_AREA
}

const TILE_SIZE := Vector2(112.0, 56.0)

@export var kind: AuthoringKind = AuthoringKind.BUILDING:
	set(value):
		kind = value
		queue_redraw()

@export var grid_position := Vector2i.ZERO:
	set(value):
		grid_position = value
		_sync_position_to_grid()
		queue_redraw()

@export var footprint := Vector2i.ONE:
	set(value):
		footprint = Vector2i(maxi(1, value.x), maxi(1, value.y))
		queue_redraw()

@export var display_name := ""
@export var actor_id := ""
@export var height_tiles := 1.0:
	set(value):
		height_tiles = maxf(0.0, value)
		queue_redraw()

@export var color := Color(0.70, 0.64, 0.52):
	set(value):
		color = value
		queue_redraw()

@export var roof_color := Color(0.16, 0.31, 0.46):
	set(value):
		roof_color = value
		queue_redraw()

@export var awning_color := Color(0.0, 0.0, 0.0, 0.0):
	set(value):
		awning_color = value
		queue_redraw()

@export var blocks_movement := false:
	set(value):
		blocks_movement = value
		queue_redraw()


func _ready() -> void:
	_sync_position_to_grid()
	queue_redraw()


func _process(_delta: float) -> void:
	if Engine.is_editor_hint() and position != grid_to_iso(grid_position):
		_sync_position_to_grid()


func get_authoring_kind() -> int:
	return int(kind)


func _sync_position_to_grid() -> void:
	position = grid_to_iso(grid_position)


func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	var preview_color := color
	preview_color.a = 0.45
	draw_colored_polygon(_footprint_polygon(), preview_color)
	if blocks_movement:
		draw_polyline(_footprint_polygon(), Color(1.0, 0.25, 0.18, 0.85), 3.0, true)
	else:
		draw_polyline(_footprint_polygon(), Color(0.2, 0.8, 1.0, 0.7), 2.0, true)


func _footprint_polygon() -> PackedVector2Array:
	return PackedVector2Array([
		Vector2.ZERO,
		grid_to_iso(Vector2i(footprint.x, 0)),
		grid_to_iso(footprint),
		grid_to_iso(Vector2i(0, footprint.y))
	])


static func grid_to_iso(grid: Vector2i) -> Vector2:
	var x := float(grid.x - grid.y) * TILE_SIZE.x * 0.5
	var y := float(grid.x + grid.y) * TILE_SIZE.y * 0.5
	return Vector2(x, y)
