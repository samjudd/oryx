extends Node2D
class_name OryxPlayerController

func _input(event: InputEvent) -> void:
	# if you mouseover a hex, highlight it
	if event is InputEventMouseMotion:
		pass
		
	# on click, print path to node we clicked on
	if event.is_action_pressed("mouseClick"):
		var map : OryxTileMapLayer = get_node("../OryxLevel/BaseLayer")
		var clickedHex : Vector2i = map.GetHexPosAtGlobalPosition(event.global_position)
		if clickedHex != Vector2i(-1, -1):
			print(map.FindPath(Vector2i(0,1), clickedHex))

func _draw() -> void:
	pass
