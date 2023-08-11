extends Control
tool

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
	convert_map()


func _on_TilesetOpener_file_selected(path):
	$HBoxContainer/Panel/RichTextLabel.bbcode_text = ($HBoxContainer/Panel/RichTextLabel.bbcode_text + "selected " + $TilesetOpener.current_file + " as the tileset" + "\n")
	requiredPaths[1] = path
	if requiredPaths[0] != null:
		$HBoxContainer/VBoxContainer/Convert.disabled = false

func _on_JsonOpener_file_selected(path):
	$HBoxContainer/Panel/RichTextLabel.bbcode_text = ($HBoxContainer/Panel/RichTextLabel.bbcode_text + "selected " + $JsonOpener.current_file + " as the map" + "\n")
	requiredPaths[0] = path
	if requiredPaths[1] != null:
		$HBoxContainer/VBoxContainer/Convert.disabled = false

func convert_map():
	for button in $HBoxContainer/VBoxContainer.get_children():
		button.disabled = true
	$HBoxContainer/Panel/RichTextLabel.bbcode_text = $HBoxContainer/Panel/RichTextLabel.bbcode_text + '\n[color=#ead72a]processing ' + requiredPaths[0] + "[/color]"
