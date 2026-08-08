extends Node

@onready var tile_map: TileMap = $"../TileMap"
@onready var tile_map_2: TileMap = $"../TileMap2"

@onready var file_dialog: FileDialog = $FileDialog
@onready var tile_map_3: TileMap = $"../TileMap3"
@onready var tile_map_4: TileMap = $"../TileMap4"
@onready var tile_map_5: TileMap = $"../TileMap5"

@onready var object_manage: Node = $"../ObjectManage"

@onready var tilemaps = [
	tile_map,
	tile_map_2,
	tile_map_3,
	tile_map_4,
	tile_map_5
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	file_dialog.show()
	


func _on_file_dialog_file_selected(path: String) -> void:
	tile_map.map_file = path
	tile_map_2.map_file = path.get_basename() + ".gap"
	tile_map_3.map_file = path.get_basename() + ".ddp"
	tile_map_4.map_file = path.get_basename() + ".dap"
	tile_map_5.map_file = path.get_basename() + ".wap"
	get_tree().paused = false
	for i in tilemaps:
		print("Eminitng signal generate in ", i.name)
		i.emit_signal("generate")
	await get_tree().create_timer(2).timeout
	object_manage.map_dic()
