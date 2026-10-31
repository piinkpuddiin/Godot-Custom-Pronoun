@tool
@icon("res://addons/at-icons/control/arrows_clockwise.svg")
class_name CycleButton
extends Button

signal option_changed

@export_enum('REVERSE', 'FORWARD') var direction = 'FORWARD'
@export var options: Array[String]
@export var selected_option:= 0

func _ready() -> void:
	var custom_option = 'custom'
	options.append(custom_option)
	
	get_label().text = options.get(selected_option)
	get_reverse_button().option_changed.connect(updated_selection)


func get_reverse_button() -> ReverseCycleButton:
	var button
	for i in get_parent().get_children():
		if i is ReverseCycleButton:
			button = i
	return button


func get_label() -> Control:
	var label
	for i in get_parent().get_children():
		if i is Label or i is RichTextLabel:
			label = i
	return label


func get_line_edit() -> LineEdit:
	var line_edit
	for i in get_parent().get_children():
		if i is LineEdit:
			line_edit = i
	return line_edit



func updated_selection(value):
	selected_option = value


func _pressed() -> void:
	if direction == 'FORWARD':
		selected_option += 1
		
		if selected_option == options.size():
			selected_option = 0
		
	elif direction == 'REVERSE':
		selected_option -= 1
		
		if selected_option == -1:
			selected_option = options.size()-1
	
	option_changed.emit(selected_option)
	
	get_label().text = options.get(selected_option)
	get_label().visible = !get_label().text == 'custom'
	get_line_edit().visible = get_label().text == 'custom'
