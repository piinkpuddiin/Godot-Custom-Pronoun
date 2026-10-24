extends Control

@export var dialogue: Control
@export var custom_pronouns: Array[Control]
@export var example_sentences: Array[Control]

func _ready() -> void:
	self.hide()


func _on_confirm_button_pressed() -> void:
	for i in custom_pronouns:
		i.hide()
	for i in example_sentences:
		i.hide()
	dialogue.start_dialogue()
	
	self.hide()


func _on_close_button_pressed() -> void:
	self.hide()
