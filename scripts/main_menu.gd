extends Control

@export var custom_pronouns: Control
@export var dialogue: Control

func _ready() -> void:
	%dialogue_button.disabled = true
	P.loaded_pronouns.connect(load_data)

func _on_pronouns_button_pressed() -> void:
	self.hide()

func _on_dialogue_button_pressed() -> void:
	self.hide()
	custom_pronouns.hide()
	dialogue.start_dialogue()

func _on_load_button_pressed() -> void:
	P.loaded_pronouns.emit(custom_pronouns.save_name)

func load_data(save_name):
	P.player_pronouns = P._load(save_name).get("pronouns")
	%dialogue_button.disabled = false
