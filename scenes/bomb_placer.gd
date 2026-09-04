extends Node

@onready var mines_tilemap: TileMap = $"../Mines"
@onready var object_manage: Node = $"../ObjectManage"
@onready var game_manager: Node = $"../GameManager"
@onready var rng = RandomNumberGenerator.new()
@onready var grid_tilemap: TileMap = $"../TileMap2"

const mine: Vector2i = Vector2i(7, 0)
const source = 0

const default_layer: int = 0
const last_layer: int = 1
var last_kolo: int = 3
var last_kolo_place: int = 2
var mine_pos: Vector2i = Vector2i(-1, -1)

@onready var mines: Array = object_manage.mines

func _process(_delta: float) -> void:
	if last_kolo == game_manager.kolo:
		mines_tilemap.set_cell(last_layer, mine_pos)
		mines_tilemap.set_cell(default_layer, mine_pos, source, mine)
		last_kolo = game_manager.kolo + 1

	if last_kolo_place == game_manager.kolo:
		print("umistuji bombu na default layer")
		
		while is_occupied(mine_pos):
			var rng_mine = get_random_map_position()
			mine_pos = rng_mine
			print("bomba zkousim na: ", mine_pos)
			print("Stav: ", is_occupied(mine_pos))
		mines.append(mine_pos)
		mines_tilemap.set_cell(last_layer, mine_pos, source, mine)
		last_kolo_place = game_manager.kolo + 1

func is_occupied(coords: Vector2i) -> bool:
	if coords == Vector2i(-1, -1):
		return true # Neplatná pozice z find_powerup_loc
	
	# 1. Kontrola, zda už na TileMapě na této vrstvě něco je
	if mines_tilemap.get_cell_source_id(default_layer, coords) != -1:
		for i in object_manage.ddp:
			var array_ddp = object_manage.ddp[i]
			for j in array_ddp:
				if j == coords:
					return false
		return true
		
	# 2. Kontrola, zda tam už není zapsaný jiný powerup v dictionary
	if coords in mines:
		return true
		
	return false

func get_random_map_position() -> Vector2i:
	# Získáme rozsah použitých buněk na TileMapě
	var used_rect: Rect2i = grid_tilemap.get_used_rect()
	
	# Pokud chceme generovat i na okrajích (např. vnitřek mapy od 1 do end-1):
	var min_x = used_rect.position.x
	var max_x = used_rect.end.x - 1  # end.x je exkluzivní, proto -1
	
	var min_y = used_rect.position.y
	var max_y = used_rect.end.y - 2
	print("Velikost mapy je: min: ", min_x, "x", min_y," a max: ", max_x + 1, "x", max_y+ 1)
	# Pokud nechceš generovat bomby do vnějších zdí (CORNER / UP / LEFT),
	# posuň hranice o +1 / -1:
	# min_x += 1; max_x -= 1
	# min_y += 1; max_y -= 1

	return Vector2i(
		rng.randi_range(min_x, max_x),
		rng.randi_range(min_y, max_y)
	)
