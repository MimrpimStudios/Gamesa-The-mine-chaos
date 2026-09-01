extends Node

@onready var tile_map_3: TileMap = $"../TileMap3"
@onready var game_manager: Node = $"../GameManager"
@onready var object_manage: Node = $"../ObjectManage"
@onready var rng = RandomNumberGenerator.new()
var spawn_kolo: int = -1
var power_up_id = 0
var power_up_layer_id = 1
const powerups: Dictionary = {
#	"radar": Vector2i(8, 0),
#	"trail": Vector2i(9, 0),
	"swap": Vector2i(10, 0),
}
func _process(_delta: float) -> void:
	if game_manager.kolo == 2 and spawn_kolo == -1:
		spawn_kolo = rng.randi_range(0, 2) + 2

	if spawn_kolo == game_manager.kolo:
		spawn_kolo = spawn_kolo + rng.randi_range(3, 5)
		
		var rand_key = powerups.keys().pick_random()
		var rand_value = powerups[rand_key]
		print("Klíč: ", rand_key, " | Hodnota: ", rand_value)
		
		var loc1 = find_powerup_loc()
		var pos1 = Vector2i(loc1.x, loc1.y - 1) if loc1 != Vector2i(-1, -1) else Vector2i(-1, -1)

		var loc2 = find_powerup_loc2()
		var pos2 = Vector2i(loc2.x, loc2.y + 1) if loc2 != Vector2i(-1, -1) else Vector2i(-1, -1)

		# Náhodné určení, která možnost se zkusí jako první
		var first_choice = pos1 if rng.randi_range(0, 1) == 0 else pos2
		var second_choice = pos2 if first_choice == pos1 else pos1

		var final_coords = Vector2i(-1, -1)

		# Zkusí první možnost, pokud je obsazená, zkusí druhou
		if not is_occupied(first_choice):
			final_coords = first_choice
		elif not is_occupied(second_choice):
			final_coords = second_choice

		# Pokud se našlo volné políčko, zapíše se. Pokud jsou obě obsazená, nestane se nic.
		if final_coords != Vector2i(-1, -1):
			tile_map_3.set_cell(power_up_layer_id, final_coords, power_up_id, rand_value)
			# Klíč je pozice, hodnota je typ powerupu
			object_manage.powerups[final_coords] = rand_key 
			print("Powerups: ", object_manage.powerups)
		else:
			print("Obě políčka byla obsazená, powerup se neukládá.")


func find_powerup_loc() -> Vector2i:
	if "POWERUPRED" in object_manage.ddp:
		var red_house_positions: Array = object_manage.ddp["POWERUPRED"]
		print("Všechny pozice POWERUPRED: ", red_house_positions)
		
		if not red_house_positions.is_empty():
			# Vybere náhodnou pozici z pole
			var rand_red_house_pos: Vector2i = red_house_positions.pick_random()
			print("Vybraný POWERUPRED je na mřížce: ", rand_red_house_pos)
			return rand_red_house_pos

	print("POWERUPRED nebyl v mapě nalezen.")
	return Vector2i(-1, -1)

func find_powerup_loc2() -> Vector2i:
	if "POWERUPBLUE" in object_manage.ddp:
		var house_positions: Array = object_manage.ddp["POWERUPBLUE"]
		print("Všechny pozice POWERUPBLUE: ", house_positions)
		
		if not house_positions.is_empty():
			# Vybere náhodnou pozici z pole
			var rand_house_pos: Vector2i = house_positions.pick_random()
			print("Vybraný POWERUP je na mřížce: ", rand_house_pos)
			return rand_house_pos

	print("POWERUPBLUE nebyl v mapě nalezen (nebo je pole prázdné).")
	return Vector2i(-1, -1) # Nebo Vector2i.ZERO

func is_occupied(coords: Vector2i) -> bool:
	if coords == Vector2i(-1, -1):
		return true # Neplatná pozice z find_powerup_loc
	
	# 1. Kontrola, zda už na TileMapě na této vrstvě něco je
	if tile_map_3.get_cell_source_id(power_up_layer_id, coords) != -1:
		return true
		
	# 2. Kontrola, zda tam už není zapsaný jiný powerup v dictionary
	if coords in object_manage.powerups.values():
		return true
		
	return false
