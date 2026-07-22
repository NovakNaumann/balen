extends RefCounted
class_name MapAssetCatalog

const ASSET_CUSTOM := "custom"

const RENDER_AUTO := 0
const RENDER_GROUND_REGION := 1
const RENDER_BUILDING_MASS := 2
const RENDER_MODULAR_BLOCK := 3
const RENDER_MARKER := 4
const RENDER_ACTOR := 5
const RENDER_COMBAT_AREA := 6

const ASSETS := {
	"ground.road.primary_boulevard": {
		"label": "Road - Primary Boulevard",
		"category": "Ground/Road",
		"kind": 0,
		"render_style": RENDER_GROUND_REGION,
		"footprint": Vector2i(9, 12),
		"height": 0.0,
		"color": Color(0.82, 0.78, 0.66),
		"blocks_movement": false
	},
	"ground.road.ring_segment": {
		"label": "Road - Ring Segment",
		"category": "Ground/Road",
		"kind": 0,
		"render_style": RENDER_GROUND_REGION,
		"footprint": Vector2i(12, 3),
		"height": 0.0,
		"color": Color(0.84, 0.79, 0.66),
		"blocks_movement": false
	},
	"ground.sidewalk.civic_apron": {
		"label": "Sidewalk - Civic Apron",
		"category": "Ground/Sidewalk",
		"kind": 1,
		"render_style": RENDER_GROUND_REGION,
		"footprint": Vector2i(12, 8),
		"height": 0.0,
		"color": Color(0.58, 0.56, 0.51),
		"blocks_movement": false
	},
	"ground.foundation.masonry": {
		"label": "Foundation - Masonry Fill",
		"category": "Ground/Foundation",
		"kind": 2,
		"render_style": RENDER_GROUND_REGION,
		"footprint": Vector2i(4, 4),
		"height": 0.0,
		"color": Color(0.32, 0.31, 0.27),
		"blocks_movement": false
	},
	"building.civic_facade_blue": {
		"label": "Building - Civic Facade Blue Roof",
		"category": "Architecture/Building",
		"kind": 3,
		"render_style": RENDER_BUILDING_MASS,
		"footprint": Vector2i(5, 7),
		"height": 4.2,
		"color": Color(0.69, 0.64, 0.54),
		"roof_color": Color(0.12, 0.27, 0.43),
		"blocks_movement": true
	},
	"building.guild_front": {
		"label": "Building - Guild Front",
		"category": "Architecture/Building",
		"kind": 3,
		"render_style": RENDER_BUILDING_MASS,
		"footprint": Vector2i(4, 5),
		"height": 3.7,
		"color": Color(0.58, 0.56, 0.50),
		"roof_color": Color(0.16, 0.18, 0.18),
		"awning_color": Color(0.30, 0.32, 0.31),
		"blocks_movement": true
	},
	"building.arcade_row": {
		"label": "Building - Arcade Row",
		"category": "Architecture/Building",
		"kind": 3,
		"render_style": RENDER_BUILDING_MASS,
		"footprint": Vector2i(8, 3),
		"height": 3.2,
		"color": Color(0.66, 0.58, 0.46),
		"roof_color": Color(0.43, 0.25, 0.18),
		"awning_color": Color(0.54, 0.34, 0.22),
		"blocks_movement": true
	},
	"market.stall.blue": {
		"label": "Market - Blue Stall",
		"category": "Market/Modular",
		"kind": 4,
		"render_style": RENDER_MODULAR_BLOCK,
		"footprint": Vector2i.ONE,
		"height": 0.85,
		"color": Color(0.16, 0.27, 0.55),
		"blocks_movement": false
	},
	"market.stall.row": {
		"label": "Market - Stall Row",
		"category": "Market/Modular",
		"kind": 4,
		"render_style": RENDER_MODULAR_BLOCK,
		"footprint": Vector2i(1, 3),
		"height": 0.85,
		"color": Color(0.55, 0.35, 0.22),
		"blocks_movement": false
	},
	"civic.banner.blue_gold": {
		"label": "Civic - Blue Gold Banner",
		"category": "Civic/Marker",
		"kind": 8,
		"render_style": RENDER_MARKER,
		"footprint": Vector2i.ONE,
		"height": 1.4,
		"color": Color(0.12, 0.22, 0.50),
		"blocks_movement": false
	},
	"route.marker": {
		"label": "Route - Exit Marker",
		"category": "Route/Marker",
		"kind": 5,
		"render_style": RENDER_MARKER,
		"footprint": Vector2i.ONE,
		"height": 0.55,
		"color": Color(0.73, 0.65, 0.50),
		"blocks_movement": false
	},
	"crowd.marker": {
		"label": "Crowd - Placeholder",
		"category": "Crowd/Marker",
		"kind": 7,
		"render_style": RENDER_MARKER,
		"footprint": Vector2i.ONE,
		"height": 1.0,
		"color": Color(0.25, 0.17, 0.18),
		"blocks_movement": false
	},
	"combat.same_scene_area": {
		"label": "Combat - Same Scene Area",
		"category": "Combat/Area",
		"kind": 9,
		"render_style": RENDER_COMBAT_AREA,
		"footprint": Vector2i(11, 7),
		"height": 0.0,
		"color": Color(0.20, 0.55, 0.78, 0.60),
		"blocks_movement": false
	}
}


static func get_asset(asset_id: String) -> Dictionary:
	if ASSETS.has(asset_id):
		return ASSETS[asset_id]
	return {}


static func has_asset(asset_id: String) -> bool:
	return ASSETS.has(asset_id)
