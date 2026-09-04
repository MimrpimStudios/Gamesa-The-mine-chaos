extends TileMap


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_layer_modulate(0, Color(0.0, 0.0, 0.0, 0.0))
	print("Mines are ready...")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
