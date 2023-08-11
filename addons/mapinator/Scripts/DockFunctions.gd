extends Control
tool

var mapName = ""
var requiredPaths = [null,null]

# Called when the node enters the scene tree for the first time.
func _ready():
	$JsonOpener.set_filters(PoolStringArray(["*.json ; JSON files"]))
	$TilesetOpener.set_filters(PoolStringArray(["*.Tres ; Tileset file"]))
	
	$HBoxContainer/VBoxContainer/Convert.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Json_pressed():
	#print("kys")
	#$HBoxContainer/Panel/RichTextLabel.bbcode_text = $HBoxContainer/Panel/RichTextLabel.bbcode_text + "\n kys"
	$JsonOpener.mode = FileDialog.MODE_OPEN_FILE
	$JsonOpener.popup_centered(Vector2(800, 700))



func _on_Tileset_pressed():
	$TilesetOpener.mode = FileDialog.MODE_OPEN_FILE
	$TilesetOpener.popup_centered(Vector2(800, 700))

func _on_Clear_pressed():
	$HBoxContainer/Panel/RichTextLabel.bbcode_text = ""


func _on_Convert_pressed():
	create_map()


func _on_TilesetOpener_file_selected(path):
	Console("selected \"" + $TilesetOpener.current_file + "\" as the tileset")
	requiredPaths[1] = path
	if requiredPaths[0] != null:
		$HBoxContainer/VBoxContainer/Convert.disabled = false

func _on_JsonOpener_file_selected(path):
	Console("selected \"" + $JsonOpener.current_file + "\" as the map")
	mapName = $JsonOpener.current_file
	mapName = mapName.replace(".json",".tscn")
	requiredPaths[0] = path
	if requiredPaths[1] != null:
		$HBoxContainer/VBoxContainer/Convert.disabled = false

func create_map():
	for button in $HBoxContainer/VBoxContainer.get_children():
		button.disabled = true
	Console('\n[color=#ead72a]processing \"' + requiredPaths[0] + "\"[/color]")
	
	var node2d = Node2D.new()
	
	var scene = PackedScene.new()
	
	var file = File.new();
	file.open(requiredPaths[0], File.READ);
	var map = parse_json(file.get_as_text())
	
	if map.has("properties"):
		for prop in map.properties:
			if prop.name == "music":
				if prop.value != "":
					Console("map has a music track called " + prop.value)
	
	if map.has("layers"):
		for layers in range(0,map.layers.size()):
			var tilemap = TileMap.new() 
			tilemap.cell_size = Vector2(map.tilewidth,map.tileheight)
			tilemap.name = map.layers[layers].name
			tilemap.tile_set = load(requiredPaths[1])
			tilemap.cell_y_sort = true
			
			var collection = false
			
			#if map.layers[layers].has("properties"):
				#for prop in map.layers[layers].properties:
					#var props = prop
					#if props.name == "imagesCollection":
						#if props.value == true:
							#tilemap.tile_set = load(tileset2Path)
							#collection = true
							
						
					
							
						
			
			node2d.add_child(tilemap)
			tilemap.set_owner(node2d)
			if map.layers[layers].has("data"):
				for i in range(0,map.layers[layers].data.size()):
					var tile = -1
					tile = int(map.layers[layers].data[i]-1)
					
					
					var array_x = (int(i)%int(map.layers[layers].width))*map.tilewidth
					var array_y = floor(i/map.layers[layers].width)*map.tileheight
					var pos = Vector2(array_x,array_y)
					var cell = tilemap.world_to_map(pos)
					
					var atlas_image = tilemap.tile_set.tile_get_texture(0)
					var atlas_X = tile % (atlas_image.get_width()/int(map.tilewidth))
					var atlas_Y = floor(tile / (atlas_image.get_width()/int(map.tilewidth)))
				
				
					if tile > -1:
						if map.tilesets.size() != 1:
							if tile >= map.tilesets[1].firstgid-1:
								tilemap.set_cell(
									cell.x,
									cell.y,
									tile-(map.tilesets[1].firstgid-2))
							else:
								tilemap.set_cell(
									cell.x,
									cell.y,
									0,
									false,
									false,
									false,
									Vector2(atlas_X,atlas_Y))
						else:
							tilemap.set_cell(
									cell.x,
									cell.y,
									0,
									false,
									false,
									false,
									Vector2(atlas_X,atlas_Y))
						
						
					
					
					
					
			elif map.layers[layers].has("objects"):
				for object in map.layers[layers].objects:
					if object.type == "npc":
						var node = load("res://npc.tscn")
						var npcNode = node.instance()
						npcNode.position = Vector2(object.x+(object.width/2),object.y+(object.height/2))
						
						tilemap.add_child(npcNode)
						
						if object.type == "door":
							var dnode = load("res://door.tscn")
							var doorNode = dnode.instance()
							doorNode.get_node("CollisionShape2D").shape = doorNode.get_node("CollisionShape2D").shape.duplicate()
							doorNode.get_node("CollisionShape2D").shape.extents = Vector2(object.width/2,object.height/2)
							doorNode.position = Vector2(object.x+object.width/2,object.y+object.height/2)
							tilemap.add_child(doorNode)
			else:
				Console("[color=#ca4539]ERROR - no data found :-([/color]")
				clean_up()
				node2d.queue_free()
#						for props in object.properties:
#							if props.name == "sprite":
#								print(props.value)
#							if props.name == "dialogue":
#								print(props.value)
#
						
						
					
	else: 
		Console("[color=#ca4539]ERROR - no layers found :-([/color]")
		clean_up()
		node2d.queue_free()
	
	scene.pack(node2d)
	ResourceSaver.save(("res://Scenes/" + mapName), scene)
	
	file.close()
	
	Console("[color=#a5e359]successfully created the map at \"" + ("res://Scenes/" + mapName) + "\"[/color]")
	
	clean_up()
	

func clean_up():
	for button in $HBoxContainer/VBoxContainer.get_children():
		button.disabled = false
	$HBoxContainer/VBoxContainer/Convert.disabled = true

func Console(string:String):
	$HBoxContainer/Panel/RichTextLabel.bbcode_text = $HBoxContainer/Panel/RichTextLabel.bbcode_text + string + "\n"
