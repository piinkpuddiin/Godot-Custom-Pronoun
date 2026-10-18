extends Control

@export var custom_pronouns: Control
@export var _notification: Control
@export var default_pronouns_vbox: VBoxContainer

func _ready() -> void:
	self.hide()
	generate_default_buttons()


## Creates the default pronoun buttons.
func generate_default_buttons() -> void:
	# Remove all the pronoun buttons.
	for i in default_pronouns_vbox.get_children():
		if i.name.begins_with("add"):
			continue
		i.queue_free()
	
	# Create all the pronoun buttons.
	for i in P.default_pronouns.keys():
		var button:= Button.new()
		var pronoun = i
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		button.toggle_mode = true
		button.name = i + "_button"
		button.text = P.default_pronouns[i]['subjective'].capitalize() + "/" + P.default_pronouns[i]['objective'].capitalize()
		button.toggled.connect(_toggle_default_pronouns.bind(pronoun))
		
		default_pronouns_vbox.add_child(button)
		default_pronouns_vbox.move_child(button, -1)

## Create the toggle function for the default buttons.
func _toggle_default_pronouns(toggled_on: bool, default_pronoun: String) -> void:
	if toggled_on:
		P.player_pronouns[default_pronoun] = {}
		P.player_pronouns[default_pronoun]['verbs'] = {}
		P.player_pronouns[default_pronoun]['pronouns'] = P.default_pronouns[default_pronoun]
	else:
		# Remove the pronoun key from the player dict. Does not delete the pronoun.
		if P.player_pronouns.get(default_pronoun):
			print("Erased pronoun: ", default_pronoun)
			P.player_pronouns.erase(default_pronoun)

## Set the pronouns verbs.
func set_verbs() -> void:
	for i in P.player_pronouns.keys():
		var value:= 0
		if i == "they":
			value = 1
		
		P.player_pronouns[i]['verbs']['are'] = value
		P.player_pronouns[i]['verbs']['arent'] = value
		P.player_pronouns[i]['verbs']['were'] = value
		P.player_pronouns[i]['verbs']['have'] = value
		P.player_pronouns[i]['verbs']['dont'] = value
		P.player_pronouns[i]['verbs']['s'] = value
		P.player_pronouns[i]['verbs']['es'] = value

func _on_confirm_button_pressed() -> void:
	set_verbs()
	_notification.show()
	self.hide()
	P._save(custom_pronouns.save_name)
