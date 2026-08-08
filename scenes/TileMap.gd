extends TileMap

const FILLER = "."
signal generate
@export var letter_to_atlas_coord: Dictionary[String, Vector2i] = {
	"CORNER1": Vector2i(3,1),
	"CORNER2": Vector2i(6,1),
	"CORNER3": Vector2i(3,6),
	"CORNER4": Vector2i(6,6),
	"FILL": Vector2i(4,2),
	"UP1": Vector2i(4,1),
	"UP2": Vector2i(5,1),
	"LEFT": Vector2i(3,2),
	"RIGHT": Vector2i(6,2),
	"DOWN1": Vector2i(4,6),
	"DOWN2": Vector2i(5,6),

}

@export var main_layer = 0
@export var main_source_id: int = 1
@export var map_file = "res://levels/level1.txt"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await generate
	emit_signal("generate")
	print(name, " is generating...")
	load_level_file(map_file)


func load_level_file(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if not file:
		OS.alert("The map file not found!", "Error!")
		return
	var contents = file.get_as_text().replace("\r\n", "\n")
	var sections = contents.split("\n\n", false)
	var level_contents = sections[0]
	place_tiles_based_on_string(level_contents)
	if len(sections) > 1:
		var settings = sections[1]
		read_settings(settings)

func place_tiles_based_on_string(level_contents: String):
	var board = level_contents.strip_edges().split("\n", false) as Array
	board = board.map(func(line: String): return line.strip_edges().split(" ", false))
	
	for y in range(len(board)):
		for x in range(len(board[y])):
			var tile_key = board[y][x]
			
			if tile_key == FILLER:
				continue
			
			# Vyhledá celý klíč (např. "gc") ve slovníku a vykreslí ho do vrstvy 0
			if tile_key in letter_to_atlas_coord:
				set_cell(0, Vector2i(x, y), main_source_id, letter_to_atlas_coord[tile_key])

func read_settings(settings: String):
	var target_width: int = -1
	var target_height: int = -1

	for setting in settings.split("\n", false):
		var setting_name_and_value = setting.split("=", false, 1)
		if setting_name_and_value.size() < 2:
			continue

		var setting_name = setting_name_and_value[0].strip_edges()
		var setting_value = setting_name_and_value[1].strip_edges()

		if setting_name == "sizex":
			if not setting_value.is_valid_int():
				OS.alert("The map sizex setting is not a valid integer!", "Error!")
				OS.crash("The map sizex setting is not a valid integer!")
			target_width = int(setting_value) * 16

		elif setting_name == "sizey":
			if not setting_value.is_valid_int():
				OS.alert("The map sizey setting is not a valid integer!", "Error!")
				OS.crash("The map sizey setting is not a valid integer!")
			target_height = int(setting_value) * 16

	if target_width != -1 or target_height != -1:
		var current_size = DisplayServer.window_get_size()
		var new_width = target_width if target_width != -1 else current_size.x
		var new_height = target_height if target_height != -1 else current_size.y
		var new_size = Vector2i(new_width, new_height)

		# 1. Změníme rozlišení vnitřního Viewportu (aby 1 pixel v TileMapě odpovídal přesně 1 pixelu na obrazovce)
		get_tree().root.content_scale_size = new_size

		# 2. Změníme rozměr fyzického okna OS
		DisplayServer.window_set_size(new_size)

		# 3. Vynutíme překreslení
		RenderingServer.force_draw()
