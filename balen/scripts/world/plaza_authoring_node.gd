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

var _is_syncing_position := false

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
	if not Engine.is_editor_hint() or _is_syncing_position:
		return

	var expected_position := grid_to_iso(grid_position)
	if position == expected_position:
		return

	grid_position = world_to_grid(position)


func get_authoring_kind() -> int:
	return int(kind)


func _sync_position_to_grid() -> void:
	_is_syncing_position = true
	position = grid_to_iso(grid_position)
	_is_syncing_position = false


func _draw() -> void:
	if not Engine.is_editor_hint():
		return

	var preview_color := color
	preview_color.a = _preview_alpha()
	draw_colored_polygon(_footprint_polygon(), preview_color)
	if blocks_movement:
		draw_polyline(_footprint_polygon(), Color(1.0, 0.25, 0.18, 0.85), 3.0, true)
	else:
		draw_polyline(_footprint_polygon(), _preview_outline_color(), _preview_outline_width(), true)


func _preview_alpha() -> float:
	if kind == AuthoringKind.ROAD or kind == AuthoringKind.SIDEWALK or kind == AuthoringKind.FOUNDATION:
		return 0.78
	return 0.45


func _preview_outline_color() -> Color:
	match kind:
		AuthoringKind.ROAD:
			return Color(1.0, 0.86, 0.42, 0.96)
		AuthoringKind.SIDEWALK:
			return Color(0.66, 0.72, 0.76, 0.92)
		AuthoringKind.FOUNDATION:
			return Color(0.42, 0.42, 0.36, 0.88)
		_:
			return Color(0.2, 0.8, 1.0, 0.7)


func _preview_outline_width() -> float:
	if kind == AuthoringKind.ROAD or kind == AuthoringKind.SIDEWALK or kind == AuthoringKind.FOUNDATION:
		return 3.0
	return 2.0


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


static func world_to_grid(world_position: Vector2) -> Vector2i:
	var grid_x := (world_position.x / (TILE_SIZE.x * 0.5) + world_position.y / (TILE_SIZE.y * 0.5)) * 0.5
	var grid_y := (world_position.y / (TILE_SIZE.y * 0.5) - world_position.x / (TILE_SIZE.x * 0.5)) * 0.5
	return Vector2i(roundi(grid_x), roundi(grid_y))
