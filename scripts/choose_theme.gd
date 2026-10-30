extends Control

@export var main_menu: Control
#@export var base_arr: Array[PackedScene] = [load("res://scenes/custom_pronouns.tscn"), load("res://scenes/example_sentences.tscn")]
@export var base_theme: Array[Control]
#@export var grunge_theme: Control

func _ready() -> void:
	hide()

func _on_base_button_pressed() -> void:
	P.clear()
	
	#for i in base_arr:
	#	#i.instantiate()
	#	main_menu.add_sibling(i.instantiate())
	#for i in base_theme:
	#	i.show()
	base_theme[0].show()
	base_theme[0].clear()
	
	hide()

func _on_grunge_button_pressed() -> void:
	P.clear()
	#grunge_theme.clear()
	#grunge_theme.show()
	hide()

func _on_pastel_button_pressed() -> void:
	pass # Replace with function body.

func _on_gothic_button_pressed() -> void:
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	hide()
	main_menu.show()
