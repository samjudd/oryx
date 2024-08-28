extends TileMapLayer
class_name OryxTileMapLayer

@export var showDebugLabels : bool = true

# class vars that we'll use
var pathfinder : AStar2D = AStar2D.new()
var hexPosToNavID : Dictionary = {}

func _ready() -> void:
	_SetupBoardNavigation()
	
func FindPath(fromPos : Vector2i, toPos : Vector2i) -> Array[Vector2i]:
	# get IDs from points, then do the pathfinding 
	var fromNavID : int = hexPosToNavID[fromPos]
	var toNavID : int = hexPosToNavID[toPos]
	
	# convert the packed array to a normal one, and the vector2 to vector2i
	var path : PackedVector2Array = pathfinder.get_point_path(fromNavID, toNavID)
	var returnArray : Array[Vector2i] = []
	for point : Vector2 in path:
		returnArray.append(Vector2i(point))
	return returnArray
	
func GetHexPosAtGlobalPosition(globalPosition : Vector2) -> Vector2i:
	return local_to_map(to_local(globalPosition))
	
func GetGlobalPositionAtHexPos(hexPos : Vector2i) -> Vector2:
	return to_global(map_to_local(hexPos))

# add all hexes on the board to pathfinder and connec tthem 
func _SetupBoardNavigation() -> void: 
	var hexes : Array[Vector2i] = get_used_cells()
	for hexPos in hexes:
		# add hex to the navigation system with a new ID
		var newID : int = pathfinder.get_available_point_id()
		hexPosToNavID[hexPos] = newID
		pathfinder.add_point(newID, hexPos) # leave weight scale at 1 for now
		
		if showDebugLabels:
			_AddDebugHexLabel(hexPos)
	
	# once all the hexes are in the pathfinder, gotta connect em all up 
	for hexPos in hexes:
		for adjacentHexPos in get_surrounding_cells(hexPos):
			if get_cell_source_id(adjacentHexPos)!= -1:  # cell is valid
				var hexNavID : int = hexPosToNavID[hexPos]
				var adjacentHexNavID : int = hexPosToNavID[adjacentHexPos]
				if !pathfinder.are_points_connected(hexNavID, adjacentHexNavID):
					pathfinder.connect_points(hexNavID, adjacentHexNavID)

# Adds a label with the grid position of a hex to the world
func _AddDebugHexLabel(hexPos : Vector2i) -> void:
	var debugLabel : Label = Label.new()
	debugLabel.text = str(hexPos)
	debugLabel.scale = Vector2(0.7, 0.7)
	debugLabel.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	debugLabel.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	debugLabel.set_position(GetGlobalPositionAtHexPos(hexPos))
	add_child(debugLabel)
