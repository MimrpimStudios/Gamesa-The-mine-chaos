extends TileMap

@onready var object_manage: Node = $"../ObjectManage"
@onready var game_manager: Node = $"../GameManager"

var player_pos: Vector2i
var player_future_pos: Vector2i
var color = 0
var show_move: int = -1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up") and game_manager.turn == color:
		if not show_move == 1:
			show_move = 1
			move(1, true)
		else:
			move(1, false)
	elif Input.is_action_just_pressed("ui_down") and game_manager.turn == color:
		if not show_move == 0:
			show_move = 0
			move(0, true)
		else:
			move(0, false)
	elif Input.is_action_just_pressed("ui_left") and game_manager.turn == color:
		if not show_move == 2:
			show_move = 2
			move(2, true)
		else:
			move(2, false)
	elif Input.is_action_just_pressed("ui_right") and game_manager.turn == color:
		if not show_move == 3:
			show_move = 3
			move(3, true)
		else:
			move(3, false)

# 0 down, 1 up, 2 left, 3 right

func move(direction: int, preview: bool) -> void:
	if preview:
		match direction:
			0:
				set_cell(0, player_pos, 0, Vector2i(2, 0))
			1:
				set_cell(0, player_pos, 0, Vector2i(4, 0))
			2:
				set_cell(0, player_pos, 0, Vector2i(3, 0))
			3:
				set_cell(0, player_pos, 0, Vector2i(5, 0))
	else:
		match direction:
			0: # DOWN (dolů)
				player_future_pos = player_pos + Vector2i(0, 1)
				# Na aktuální pozici nesmí být zeď Dole a na budoucí pozici nesmí být zeď Nahoře
				if not is_wall_at("WALLDOWN", player_pos) and not is_wall_at("WALLUP", player_future_pos):
					execute_move(0)

			1: # UP (nahoru)
				player_future_pos = player_pos + Vector2i(0, -1)
				# Na aktuální pozici nesmí být zeď Nahoře a na budoucí pozici nesmí být zeď Dole
				if not is_wall_at("WALLUP", player_pos) and not is_wall_at("WALLDOWN", player_future_pos):
					execute_move(1)

			2: # LEFT (doleva)
				player_future_pos = player_pos + Vector2i(-1, 0)
				# Na aktuální pozici nesmí být zeď Vlevo a na budoucí pozici nesmí být zeď Vpravo
				if not is_wall_at("WALLLEFT", player_pos) and not is_wall_at("WALLRIGHT", player_future_pos):
					execute_move(2)

			3: # RIGHT (doprava)
				player_future_pos = player_pos + Vector2i(1, 0)
				# Na aktuální pozici nesmí být zeď Vpravo a na budoucí pozici nesmí být zeď Vlevo
				if not is_wall_at("WALLRIGHT", player_pos) and not is_wall_at("WALLLEFT", player_future_pos):
					execute_move(3)


# Pomocná funkce pro bezpečné ověření, zda je na dané pozici konkrétní typ zdi
func is_wall_at(wall_type: String, pos: Vector2i) -> bool:
	if not object_manage.walls.has(wall_type):
		return false
		
	var wall_list = object_manage.walls[wall_type]
	
	# Zkontrolujeme Vector2i
	if pos in wall_list:
		return true
		
	# Zkontrolujeme Array [x, y]
	if [pos.x, pos.y] in wall_list:
		return true
		
	# Zkontrolujeme PackedInt32Array / Tuple formáty
	for element in wall_list:
		if element is Vector2i and element == pos:
			return true
		elif (element is Array or element is PackedInt32Array) and element.size() >= 2:
			if element[0] == pos.x and element[1] == pos.y:
				return true

	return false

func execute_move(direction: int) -> void:
	show_move = -1
	game_manager.turn = -1
	match direction:
		0:
			set_cell(0, player_pos, 0, Vector2i(2, 0))
			await get_tree().create_timer(0.5).timeout
			set_cell(0, player_pos, -1)
			set_cell(0, player_future_pos, 0, Vector2i(2, 0))
			player_pos = player_future_pos
			await get_tree().create_timer(0.5).timeout
			set_cell(0, player_pos, 0, Vector2i(0, 0))
			player_pos = player_future_pos
		1:
			set_cell(0, player_pos, 0, Vector2i(4, 0))
			await get_tree().create_timer(0.5).timeout
			set_cell(0, player_pos, -1)
			set_cell(0, player_future_pos, 0, Vector2i(4, 0))
			player_pos = player_future_pos
			await get_tree().create_timer(0.5).timeout
			set_cell(0, player_pos, 0, Vector2i(0, 0))
			player_pos = player_future_pos
		2:
			set_cell(0, player_pos, 0, Vector2i(3, 0))
			await get_tree().create_timer(0.5).timeout
			set_cell(0, player_pos, -1)
			set_cell(0, player_future_pos, 0, Vector2i(3, 0))
			player_pos = player_future_pos
			await get_tree().create_timer(0.5).timeout
			set_cell(0, player_pos, 0, Vector2i(0, 0))
			player_pos = player_future_pos
		3:
			set_cell(0, player_pos, 0, Vector2i(5, 0))
			await get_tree().create_timer(0.5).timeout
			set_cell(0, player_pos, -1)
			set_cell(0, player_future_pos, 0, Vector2i(5, 0))
			player_pos = player_future_pos
			await get_tree().create_timer(0.5).timeout
			set_cell(0, player_pos, 0, Vector2i(0, 0))
	game_manager.turn = 1

	print("Pohyb úspěšný!")
	
# Hledáme např. dlaždici se souřadnicemi Atlasu Vector2i(3, 1)
func get_unique_tile_position(target_atlas_coords: Vector2i) -> Vector2i:
	# Projít všechny položené tiles
	for cell in get_used_cells(0):
		var atlas_coords = get_cell_atlas_coords(0, cell)
		if atlas_coords == target_atlas_coords:
			print("Nalezena tile na mřížce: ", cell)
			return cell # Vrací např. Vector2i(12, 5)
			
	print("Dlaždice nebyla v mapě nalezena.")
	return Vector2i(-1, -1) # Kód pro nenalezeno


func make_player():
	if "HOME1RED" in object_manage.houses:
		var red_house_positions: Array = object_manage.houses["HOME1RED"]
		print("Všechny pozice HOME1RED: ", red_house_positions)
	
		# Pokud víš, že je v mapě jen JEDEN dům tohoto typu (první v poli):
		if red_house_positions.size() > 0:
			var red_house_pos: Vector2i = red_house_positions[0]
			print("První HOME1RED je na mřížce: ", red_house_pos)
			set_cell(0, red_house_pos, 0, Vector2i(0, 0) )
			player_pos = get_unique_tile_position(Vector2i(0, 0))
	else:
		print("HOME1RED nebyl v mapě nalezen.")
