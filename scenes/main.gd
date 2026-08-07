extends Node2D

@export var main_scene:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("loading all custom maps...")
	load_all_custom_packs()
	print("finished loading all custom maps...")
	print("jumping into game...")
	get_tree().change_scene_to_packed(main_scene)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func load_all_custom_packs() -> void:
	var source_dir = "user://custom_levels/"
	
	# Ujistíme se, že složka existuje
	if not DirAccess.dir_exists_absolute(source_dir):
		DirAccess.make_dir_recursive_absolute(source_dir)
		print("folder " + source_dir + " does not exist. Creatin one...")
		return

	var dir = DirAccess.open(source_dir)
	if not dir:
		push_error("error opening dir ", source_dir)
		OS.alert("error opening dir" + source_dir, "Error!")
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()

	while file_name != "":
		# Zpracujeme pouze soubory (ne složky) s příponou .pck nebo .zip
		if not dir.current_is_dir():
			var ext = file_name.get_extension().to_lower()
			if ext == "pck" or ext == "zip":
				var full_path = source_dir.path_join(file_name)
				
				# Třetí parametr 'true' nahradí případné soubory se stejným názvem
				var success = ProjectSettings.load_resource_pack(full_path, true)
				
				if success:
					print("Succesfuly loaded", file_name)
				else:
					push_error("Error loading ", file_name)
					OS.alert("Error loading " + file_name, "Error!")

		file_name = dir.get_next()
	
	dir.list_dir_end()
