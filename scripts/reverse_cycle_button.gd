@tool
@icon("res://addons/at-icons/control/arrows_counterclockwise.svg")
class_name ReverseCycleButton
extends Button

signal option_changed

@onready var selected = get_selected_option()

func _ready() -> void:
	get_cycle_button().option_changed.connect(updated_selection)


func get_label() -> Control:
	var label
	for i in get_parent().get_children():
		if i is Label or i is RichTextLabel:
			label = i
	return label


func get_cycle_button() -> CycleButton:
	var button
	for i in get_parent().get_children():
		if i is CycleButton:
			button = i
	return button


func get_line_edit() -> LineEdit:
	var line_edit
	for i in get_parent().get_children():
		if i is LineEdit:
			line_edit = i
	return line_edit


func get_selected_option() -> int:
	var selected_option
	for i in get_parent().get_children():
		if i is CycleButton:
			selected_option = i.selected_option
	return selected_option


func updated_selection(value):
	selected = value


func get_options() -> Array[String]:
	var options
	for i in get_parent().get_children():
		if i is CycleButton:
			options = i.options
	return options


func _pressed() -> void:
	selected -= 1
	
	if selected == -1:
		selected = get_options().size()-1
	
	option_changed.emit(selected)
	
	get_label().text = get_options().get(selected)
	get_label().visible = !get_label().text == 'custom'
	get_line_edit().visible = get_label().text == 'custom'
