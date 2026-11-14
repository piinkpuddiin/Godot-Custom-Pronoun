@icon("res://addons/at-icons/control/human.svg")
extends Control

# NOTE: The GE variables aren't saved in save/load example.
@export var main_menu: Node
@export var column_1_container:Container
@export var column_2_container:Container
@export_file('*.tscn') var expression_panel: String = 'res://scenes/base/expression_panel.tscn'

var custom_option = 'custom'

func _ready() -> void:
	add_panels(column_1_container)
	#add_panels(column_2_container)
	
	#get_cycle_buttons()
	#set_defaults_options()


func add_panels(column: Container) -> void:
	var expression_arr: Array[String]
	var global_script: GDScript = P.get_script()
	
	#print('Properties of "%s":' % [ global_script.resource_path ])
	for property_info in global_script.get_script_property_list():
		var property_name: String = property_info.name
		var _property_value = P.get(property_name)
		if P.get(property_name) is Array[String]:
			#print('we are an array')
			#print('  %s = %s' % [ property_name, property_value ])
			expression_arr.append(property_name)
	
	for i in expression_arr:
		var panel: Panel = load(expression_panel).instantiate()
		panel.name = i.trim_suffix("_arr") + "_panel"
		panel.find_child('label').text = i.trim_suffix("_arr").capitalize()
		panel.find_child('cycle_button').name = i.trim_suffix("_arr") + "_cycle_button"
		panel.find_child('expression_label').name = i.trim_suffix("_arr") + "_label"
		panel.find_child('line_edit').name = i.trim_suffix("_arr") + "_line_edit"

		column.add_child(panel)
		#print("cycle button: ", panel.find_child(i.trim_suffix("_arr") + "_cycle_button"))
		panel.find_child(i.trim_suffix("_arr") + "_line_edit").placeholder_text = P.get(i.trim_suffix("_arr"))
		panel.find_child(i.trim_suffix("_arr") + "_cycle_button").options.append_array(P.get(i))
		panel.find_child(i.trim_suffix("_arr") + "_cycle_button").options.append(custom_option)


## Set the defaults options from the P global script to the CycleButton's
#func set_defaults_options():
#	for i in get_cycle_buttons():
#		var expression_arr:= i.name.trim_suffix('_cycle_button')
#		if P.get(expression_arr):
#			i.options.append_array(P.get(expression_arr))
#		
#		i.options.append(custom_option)
#		print('yurhh')
#
#
### Returns all the CycleButton in an Array
#func get_cycle_buttons() -> Array[CycleButton]:
#	var button_arr: Array[CycleButton]
#	for i in find_children('*_cycle_button', 'Button'):
#		print('cyclebutton found!')
#		button_arr.append(i)
#	print("the button array: ",button_arr)
#	return button_arr


## Set the custom options from both RichTextLabel and the LineEdit
func set_options(column: Container) -> void:
	for i in column.find_children('*', 'RichTextLabel'):
		if i.visible:
			var variant_name = i.name.trim_suffix('_label')
			P.set(variant_name, i.text.to_lower())
			print(variant_name,": ",P.get(variant_name))
	
	for i in column.find_children('*', 'LineEdit'):
		if i.visible:
			var variant_name = i.name.trim_suffix('_line_edit')
			P.set(variant_name, i.text.to_lower())
			print(variant_name,": ",P.get(variant_name))

## Save the options from columns
func save_gender_expression() -> void:
	set_options(column_1_container)
	set_options(column_2_container)

# Save all the options set, and hide the node.
func _on_save_button_pressed() -> void:
	save_gender_expression()
	if main_menu:
		main_menu.show()
		hide()
