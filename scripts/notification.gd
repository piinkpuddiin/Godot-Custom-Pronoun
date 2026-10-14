extends Control

@export var dialogue: Control
@export var custom_pronouns: Control
@export var example_sentences: Control

func _ready() -> void:
	self.hide()


func _on_confirm_button_pressed() -> void:
	custom_pronouns.hide()
	example_sentences.hide()
	dialogue.start_dialogue()
	custom_pronouns.set_new_keys()
	
	self.hide()


func _on_close_button_pressed() -> void:
	self.hide()
