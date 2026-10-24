extends Control

@export var main_menu: Control
@export var base_theme: Control
@export var grunge_theme: Control

func _ready() -> void:
	hide()

func _on_base_button_pressed() -> void:
	P.clear()
	base_theme.clear()
	base_theme.show()
	hide()

func _on_grunge_button_pressed() -> void:
	P.clear()
	grunge_theme.clear()
	grunge_theme.show()
	hide()

func _on_pastel_button_pressed() -> void:
	pass # Replace with function body.

func _on_gothic_button_pressed() -> void:
	pass # Replace with function body.


func _on_back_button_pressed() -> void:
	hide()
	main_menu.show()
