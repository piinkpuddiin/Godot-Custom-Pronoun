extends Control

@export var custom_pronouns: Control
@export var simple_pronouns: Control
@export var dialogue: Control

func _ready() -> void:
	self.show()
	%dialogue_button.disabled = true
	check_load()
	P.saved_pronouns.connect(check_load)
	P.loaded_pronouns.connect(load_data)
	%version_label.text = "V." + str(ProjectSettings.get_setting("application/config/version"))

func check_load():
	%load_button.disabled = P.save_exists(custom_pronouns.save_name)

func _on_custom_pronouns_button_pressed() -> void:
	P.clear()
	custom_pronouns.clear()
	custom_pronouns.show()
	self.hide()

func _on_simple_pronouns_button_pressed() -> void:
	simple_pronouns.show()
	self.hide()

func _on_dialogue_button_pressed() -> void:
	self.hide()
	custom_pronouns.hide()
	dialogue.start_dialogue()

func _on_load_button_pressed() -> void:
	P.clear()
	P._load(custom_pronouns.save_name)
	P.loaded_pronouns.emit(custom_pronouns.save_name)

func load_data(save_name):
	P.player_pronouns = P._load(save_name).get("pronouns")
	%dialogue_button.disabled = false
	print_rich("[b]Loaded pronouns:[/b] ",JSON.stringify((P.player_pronouns), "  "))
