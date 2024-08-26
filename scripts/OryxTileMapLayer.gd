extends TileMapLayer
class_name OryxTileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var Cells : Array[Vector2i] = get_used_cells()
	print(Cells)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
