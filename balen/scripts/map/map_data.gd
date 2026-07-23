extends RefCounted
class_name MapData

const TERRAIN_ROAD := "road"
const TERRAIN_SIDEWALK := "sidewalk"
const TERRAIN_PATH := "path"
const TERRAIN_WATER := "water"

const DEFAULT_BOUNDS := {
	"min_x": -14,
	"max_x": 14,
	"min_y": -24,
	"max_y": 24
}


static func load_map(path: String) -> Dictionary:
	if not FileAccess.file_exists(path):
		return {}

	var text := FileAccess.get_file_as_string(path)
	var parsed: Variant = JSON.parse_string(text)
	if typeof(parsed) != TYPE_DICTIONARY:
		return {}
	return parsed


static func save_map(path: String, map_data: Dictionary) -> bool:
	var base_dir := path.get_base_dir()
	if base_dir != "":
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(base_dir))

	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false

	file.store_string(JSON.stringify(map_data, "\t") + "\n")
	return true


static func bounds(map_data: Dictionary) -> Dictionary:
	var raw_bounds: Dictionary = map_data.get("bounds", {})
	if raw_bounds.is_empty():
		return DEFAULT_BOUNDS.duplicate(true)
	return {
		"min_x": int(raw_bounds.get("min_x", DEFAULT_BOUNDS["min_x"])),
		"max_x": int(raw_bounds.get("max_x", DEFAULT_BOUNDS["max_x"])),
		"min_y": int(raw_bounds.get("min_y", DEFAULT_BOUNDS["min_y"])),
		"max_y": int(raw_bounds.get("max_y", DEFAULT_BOUNDS["max_y"]))
	}


static func grid_from_array(value: Variant, fallback := Vector2i.ZERO) -> Vector2i:
	if typeof(value) != TYPE_ARRAY:
		return fallback
	var values: Array = value
	if values.size() < 2:
		return fallback
	return Vector2i(int(values[0]), int(values[1]))


static func grid_from_terrain_entry(entry: Dictionary) -> Vector2i:
	return Vector2i(int(entry.get("x", 0)), int(entry.get("y", 0)))


static func terrain_key(grid_position: Vector2i) -> String:
	return "%d,%d" % [grid_position.x, grid_position.y]


static func color_from_array(value: Variant, fallback: Color) -> Color:
	if typeof(value) != TYPE_ARRAY:
		return fallback
	var values: Array = value
	if values.size() < 3:
		return fallback
	var alpha := 1.0
	if values.size() >= 4:
		alpha = float(values[3])
	return Color(float(values[0]), float(values[1]), float(values[2]), alpha)


static func color_to_array(color: Color) -> Array[float]:
	return [color.r, color.g, color.b, color.a]


static func terrain_color(terrain_kind: String) -> Color:
	match terrain_kind:
		TERRAIN_ROAD:
			return Color(0.82, 0.78, 0.66, 1.0)
		TERRAIN_SIDEWALK:
			return Color(0.56, 0.55, 0.50, 1.0)
		TERRAIN_PATH:
			return Color(0.62, 0.58, 0.47, 1.0)
		TERRAIN_WATER:
			return Color(0.13, 0.39, 0.54, 0.88)
		_:
			return Color(0.54, 0.52, 0.47, 1.0)


static func terrain_layer(terrain_kind: String) -> int:
	match terrain_kind:
		TERRAIN_WATER:
			return 0
		TERRAIN_SIDEWALK:
			return 1
		TERRAIN_PATH:
			return 2
		TERRAIN_ROAD:
			return 3
		_:
			return 1


static func sorted_terrain(terrain_entries: Array) -> Array[Dictionary]:
	var typed_entries: Array[Dictionary] = []
	for entry in terrain_entries:
		if typeof(entry) == TYPE_DICTIONARY:
			typed_entries.append(entry)
	typed_entries.sort_custom(_sort_terrain_entries)
	return typed_entries


static func _sort_terrain_entries(a: Dictionary, b: Dictionary) -> bool:
	var layer_a := terrain_layer(str(a.get("kind", "")))
	var layer_b := terrain_layer(str(b.get("kind", "")))
	if layer_a != layer_b:
		return layer_a < layer_b
	var y_a := int(a.get("y", 0))
	var y_b := int(b.get("y", 0))
	if y_a != y_b:
		return y_a < y_b
	return int(a.get("x", 0)) < int(b.get("x", 0))
