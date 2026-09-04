extends Node

@onready var tile_map: TileMap = $"../TileMap"
@onready var tile_map_2: TileMap = $"../TileMap2"

@onready var file_dialog: FileDialog = $FileDialog
@onready var loading_eye: AnimatedSprite2D = $CenterContainer/LoadingEye

@onready var tile_map_3: TileMap = $"../TileMap3"
@onready var tile_map_4: TileMap = $"../TileMap4"
@onready var tile_map_5: TileMap = $"../TileMap5"

@onready var object_manage: Node = $"../ObjectManage"
@onready var player_1: TileMap = $"../Player1"
@onready var player_2: TileMap = $"../Player2"

@onready var win_label: Label = $CenterContainer2/WinLabel

@onready var tilemaps = [
	tile_map,
	tile_map_2,
	tile_map_3,
	tile_map_4,
	tile_map_5
]
# 0 red
# 1 blue
var turn = -1
var kolo: int = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# the label is placeholder
	win_label.hide()
	
	get_tree().paused = true
	file_dialog.show()
	loading_eye.show()
	


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
	await object_manage.map_dic()
	print("loading player...")
	await player_1.make_player()
	await player_2.make_player()
	turn = 0
	loading_eye.hide()

func victory(color: int) -> void:
	turn = -1
	match color:
		0:
			# the label is placeholder
			win_label.text = "Player Red Wins!"
		1:
			# the label is placeholder
			win_label.text = "Player Red Wins!"
	win_label.show()


func _on_file_dialog_canceled() -> void:
	get_tree().quit(0)
