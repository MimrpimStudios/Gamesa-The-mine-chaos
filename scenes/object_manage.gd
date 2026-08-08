extends Node

@onready var tile_map_map: TileMap = $"../TileMap"
@onready var tile_map_gap: TileMap = $"../TileMap2"
@onready var tile_map_ddp: TileMap = $"../TileMap3"
@onready var tile_map_dap: TileMap = $"../TileMap4"
@onready var tile_map_wap: TileMap = $"../TileMap5"


@onready var wap_mapping = invert_dictionary(tile_map_wap.letter_to_atlas_coord)
@onready var dap_mapping = invert_dictionary(tile_map_dap.letter_to_atlas_coord)
@onready var ddp_mapping = invert_dictionary(tile_map_ddp.letter_to_atlas_coord)
@onready var gap_mapping = invert_dictionary(tile_map_gap.letter_to_atlas_coord)
@onready var map_mapping = invert_dictionary(tile_map_map.letter_to_atlas_coord)

# Slovník, kde klíčem bude název zdi a hodnotou pole pozic [Vector2i]
var walls = {}
var houses = {}
var ddp = {}
var grid = {}
var map = {}

func write_into_dictionary(tilemap:TileMap, mapping: Dictionary):
	var out_dic = {}
	
	for cell in tilemap.get_used_cells(0):
		var atlas_coords: Vector2i = tilemap.get_cell_atlas_coords(0, cell)
		
		var tile_name: String = mapping.get(atlas_coords, "UNKNOWN_TILE")
		
		print("Pozice ", cell, " -> ", tile_name)
		
		if tile_name != "UNKNOWN_TILE":
			if not out_dic.has(tile_name):
				out_dic[tile_name] = []
			out_dic[tile_name].append(cell)
	print(out_dic)
	return out_dic

func map_dic() -> void:
	walls = write_into_dictionary(tile_map_wap, wap_mapping)
	houses = write_into_dictionary(tile_map_dap, dap_mapping)
	ddp = write_into_dictionary(tile_map_ddp, ddp_mapping)
	grid = write_into_dictionary(tile_map_gap, gap_mapping)
	map = write_into_dictionary(tile_map_map, map_mapping)

func invert_dictionary(original: Dictionary) -> Dictionary:
	var inverted: Dictionary = {}
	for key in original:
		var value = original[key]
		inverted[value] = key
	return inverted
