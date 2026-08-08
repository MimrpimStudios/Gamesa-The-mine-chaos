extends TileMap

@onready var object_manage: Node = $"../ObjectManage"
@onready var game_manager: Node = $"../GameManager"

@onready var player_pos = get_unique_tile_position(Vector2i(0, 0))
var player_future_pos: Vector2i
var color = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up") and game_manager.turn == color:
		move(0)
	elif Input.is_action_just_pressed("ui_down") and game_manager.turn == color:
		move(1)
	elif Input.is_action_just_pressed("ui_left") and game_manager.turn == color:
		move(3)
	elif Input.is_action_just_pressed("ui_right") and game_manager.turn == color:
		move(4)

# 0 down
# 1 up
# 3 left
# 4 right

func move(direction: int) -> void:
	if direction == 0:
		player_future_pos = Vector2i(player_pos.x, player_pos.y + 1)
		if not player_future_pos in object_manage.walls:
			print("success")
	elif direction == 1:
		if not is_position_wall(player_future_pos):
			print("success")
	elif direction == 2:
		pass
	elif direction == 3:
		pass
	elif direction == 4:
		pass

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

func is_position_wall(pos: Vector2i) -> bool:
	for wall_type in object_manage.walls:
		# Vyhledá, zda je pozice v poli pro daný typ zdi
		if pos in object_manage.walls[wall_type]:
			return true
	return false

func make_player():
	if "HOME1BLUE" in object_manage.houses:
		var red_house_positions: Array = object_manage.houses["HOME1BLUE"]
		print("Všechny pozice HOME1BLUE: ", red_house_positions)
	
		# Pokud víš, že je v mapě jen JEDEN dům tohoto typu (první v poli):
		if red_house_positions.size() > 0:
			var red_house_pos: Vector2i = red_house_positions[0]
			print("První HOME1BLUE je na mřížce: ", red_house_pos)
			set_cell(0, red_house_pos, 0, Vector2i(0, 0) )
	else:
		print("HOME1BLUE nebyl v mapě nalezen.")
