extends Control

@export var column_1_container:Container

func _ready() -> void:
	get_cycle_buttons()
	set_defaults_options()


func get_cycle_buttons() -> Array[CycleButton]:
	var button_arr: Array[CycleButton]
	for i in column_1_container.find_children('*', 'CycleButton'):
		button_arr.append(i)
	return button_arr


func set_defaults_options():
	for i in get_cycle_buttons():
		print(i.name)
		#print(i)
