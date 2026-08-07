extends Node

@onready var tile_map: TileMap = $"../TileMap"
@onready var tile_map_2: TileMap = $"../TileMap2"

@onready var file_dialog: FileDialog = $FileDialog
@onready var file_dialog_2: FileDialog = $FileDialog2

@onready var tilemaps = [
	tile_map,
	tile_map_2
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true
	file_dialog.show()
	


func _on_file_dialog_file_selected(path: String) -> void:
	tile_map.map_file = path
	tile_map_2.map_file = path.get_basename() + ".gap"
	get_tree().paused = false
	for i in tilemaps:
		i.emit_signal("generate")
