tool
extends EditorPlugin

const MainPanel = preload("res://addons/mapinator/Panel.tscn")

var panelInstance

func _enter_tree():
	panelInstance = MainPanel.instance()
	
	add_control_to_bottom_panel(panelInstance,"Mapinator")
	
	#get_editor_interface().get_editor_viewport().add_child(panelInstance)
	
	make_visible(false)


func _exit_tree():
	if panelInstance:
		remove_control_from_bottom_panel(panelInstance)
		panelInstance.queue_free()

func has_main_screen():
	return true

func make_visible(visible):
	if panelInstance:
		panelInstance.visible = visible
		

