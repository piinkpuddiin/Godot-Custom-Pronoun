extends Control

@export var main_menu: Node
@export var column_1_container:Container
@export var column_2_container:Container


func _ready() -> void:
	get_cycle_buttons()
	set_defaults_options()


func set_defaults_options():
	for i in get_cycle_buttons():
		if i.name.begins_with('compliment'):
			i.options.append_array(P.compliment_arr)
		if i.name.begins_with('presentation'):
			i.options.append_array(P.presentation_arr)
		
		var custom_option = 'custom'
		i.options.append(custom_option)


func get_cycle_buttons() -> Array[CycleButton]:
	var button_arr: Array[CycleButton]
	for i in column_1_container.find_children('*', 'CycleButton'):
		button_arr.append(i)
	for i in column_2_container.find_children('*', 'CycleButton'):
		button_arr.append(i)
	return button_arr


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


# TODO: Save all the choices, array index, and custom line edits.
func save_gender_expression() -> void:
	set_options(column_1_container)
	set_options(column_2_container)


func _on_save_button_pressed() -> void:
	save_gender_expression()
	if main_menu:
		main_menu.show()
		hide()
