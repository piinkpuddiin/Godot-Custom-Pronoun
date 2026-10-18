extends Control

@export var main: Node
@export var dialogue: Node
@export var custom_pronouns: Node
@export var _notification: Node

@export_category("Sentences")
@export var are_sentence = " running in the woods."
@export var arent_sentence = " walking to class."
@export var were_sentence = " aware of the extent of the damage."
@export var have_sentence = " run out of time."
@export var do_sentence = " like coffee?"
@export var dont_sentence = " like candy?"
@export var s_sentence = " like a machine."
@export var es_sentence = " homework every day."

@export_category("RichTextLabel")
@export var current_pronoun_label: RichTextLabel
@export var are_label: RichTextLabel
@export var arent_label: RichTextLabel
@export var were_label: RichTextLabel
@export var have_label: RichTextLabel
@export var do_label: RichTextLabel
@export var dont_label: RichTextLabel
@export var s_label: RichTextLabel
@export var es_label: RichTextLabel

@export_category("VBoxContainer")
@export var vbox_container: VBoxContainer
@export var custom_pronouns_vbox: VBoxContainer

var curr_pronoun: String


func _ready() -> void:
	P.curr_pronoun.connect(set_pronoun)
	P.set_sentence.connect(example_sentence)
	P.curr_verb.connect(update_sentence)
	set_toggle()

## Adds all the players pronouns buttons.
func add_pronouns() -> void:
	# Clear the previous buttons.
	if custom_pronouns_vbox.get_child_count() >= 0:
		for i in custom_pronouns_vbox.get_children():
			i.queue_free()
	
	for i in P.player_pronouns.keys():
		if P.player_pronouns[i]['pronouns'].has('subjective'):
			print("All the pronouns: ", i)
			var button:= Button.new()
			button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
			button.text = (
				P.player_pronouns[i]['pronouns']['subjective'].capitalize() +
				 "/" + 
				P.player_pronouns[i]['pronouns']['objective'].capitalize()
				)
			button.name = P.player_pronouns[i]['pronouns']['subjective'] + "_button"
			
			button.tree_entered.connect(P.set_sentence.emit)
			# Set the current pronoun to the button.
			button.pressed.connect(set_pronoun.bind(i))
			button.pressed.connect(pronoun_label)
			# Check the pronoun verbs of the current pronoun.
			button.pressed.connect(check_pronoun_verbs)
			
			custom_pronouns_vbox.add_child(button)
			custom_pronouns_vbox.move_child(button, -1)


## Sets the curr_pronoun to the most recently pressed pronoun.
func set_pronoun(pronoun):
	curr_pronoun = pronoun


## Returns all the label examples in an array.
func get_check_buttons() -> Array[CheckButton]:
	var check_array: Array
	for i in vbox_container.get_children(true):
		for x in i.get_child(0).get_child(0).get_children():
			if x is CheckButton:
				check_array.append(x)
	return check_array


## Returns all the label examples in an array.
func get_label_examples() -> Array[Label]:
	var label_array: Array
	for i in vbox_container.get_children(true):
		for x in i.get_child(0).get_child(0).get_children():
			if x is RichTextLabel:
				label_array.append(x)
	return label_array

## Sets the toggle signal in all the checkbuttons
func set_toggle() -> void:
	for i in get_check_buttons():
		var verb = i.name.trim_suffix("_button")
		i.toggled.connect(set_verb.bind(i, verb))


## Set the verb to either the plural or singular form.
func set_verb(toggled_on: bool, button: CheckButton, verb: String):
	if toggled_on:
		button.text = "Plural"
		P.curr_verb.emit(curr_pronoun, verb, 1)
	else:
		button.text = "Singular"
		P.curr_verb.emit(curr_pronoun, verb, 0)


## If the pronoun already has verbs set, show them if it's selected.
func check_pronoun_verbs():
	pronoun_label()
	if P.player_pronouns.has(curr_pronoun):
		if P.player_pronouns[curr_pronoun].has('verbs'):
			update_sentence(curr_pronoun, "are", P.player_pronouns[curr_pronoun]['verbs']['are'])
			update_sentence(curr_pronoun, "arent", P.player_pronouns[curr_pronoun]['verbs']['arent'])
			update_sentence(curr_pronoun, "were", P.player_pronouns[curr_pronoun]['verbs']['were'])
			update_sentence(curr_pronoun, "have", P.player_pronouns[curr_pronoun]['verbs']['have'])
			update_sentence(curr_pronoun, "do", P.player_pronouns[curr_pronoun]['verbs']['do'])
			update_sentence(curr_pronoun, "dont", P.player_pronouns[curr_pronoun]['verbs']['dont'])
			update_sentence(curr_pronoun, "s", P.player_pronouns[curr_pronoun]['verbs']['s'])
			update_sentence(curr_pronoun, "es", P.player_pronouns[curr_pronoun]['verbs']['es'])


## Set the example sentences the first time the screen is shown.
func example_sentence() -> void:
	pronoun_label()
	
	var reversed_keys: Array
	for i in P.player_pronouns.keys():
		P.player_pronouns[i]['verbs'] = {}
		reversed_keys.append(i)
	reversed_keys.reverse()
	
	for i in reversed_keys:
		var value:= 0
		if i == "they":
			value = 1
		
		update_sentence(i, "are", value)
		update_sentence(i, "arent", value)
		update_sentence(i, "were", value)
		update_sentence(i, "have", value)
		update_sentence(i, "do", value)
		update_sentence(i, "dont", value)
		update_sentence(i, "s", value)
		update_sentence(i, "es", value)


## Sets the current label with the subjective and objective pronoun.
func pronoun_label():
	var subjective_pronoun: String 
	var objective_pronoun: String
	
	if P.player_pronouns.has(curr_pronoun):
		subjective_pronoun = P.player_pronouns[curr_pronoun]['pronouns']['subjective']
		objective_pronoun = P.player_pronouns[curr_pronoun]['pronouns']['objective']
	current_pronoun_label.text = (
		"[b]" +
		subjective_pronoun.capitalize() + 
		"/" + 
		objective_pronoun.capitalize()
	)


func update_sentence(pronoun: String, verb: String, value: int = 0) -> void:
	var subjective_pronoun: String
	var possessive_dep_pronoun: String
	
	if P.player_pronouns.has(pronoun):
		if P.player_pronouns[pronoun]['pronouns'].has('subjective'):
			subjective_pronoun = P.player_pronouns[pronoun]['pronouns']['subjective']
			possessive_dep_pronoun = P.player_pronouns[pronoun]['pronouns']['possessive_dep']
	
	# O: Singular, 1: Plural
	var pressed: bool = value
	
	match verb:
		"are":
			are_label.text = subjective_pronoun.capitalize() + " [u][i]" + P.are_arr[value] + "[/i][/u]" + are_sentence
			# NOTE: To fix
			# Gets the checkbuttons in the order they are added to the list.
			# And set the button_pressed parameter to the right value.
			get_check_buttons().get(0).button_pressed = pressed
			# Create the verb key, and add the value.
			P.player_pronouns[pronoun]['verbs']['are'] = value
		"arent":
			arent_label.text = subjective_pronoun.capitalize() + " [u][i]" + P.arent_arr[value] + "[/i][/u]" + arent_sentence
			get_check_buttons().get(1).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['arent'] = value
		"were":
			were_label.text = subjective_pronoun.capitalize() + " [u][i]" + P.were_arr[value] + "[/i][/u]" + were_sentence
			get_check_buttons().get(2).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['were'] = value
		"have":
			have_label.text = subjective_pronoun.capitalize() + " [u][i]" + P.have_arr[value] + "[/i][/u]" + have_sentence
			get_check_buttons().get(3).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['have'] = value
		"do":
			do_label.text = "[u][i]" + P.do_arr[value].capitalize() + "[/i][/u] " + subjective_pronoun + do_sentence
			get_check_buttons().get(4).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['do'] = value
		"dont":
			dont_label.text = "[u][i]" + P.dont_arr[value].capitalize() + "[/i][/u] " + subjective_pronoun + dont_sentence
			get_check_buttons().get(5).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['dont'] = value
		"s":
			s_label.text = subjective_pronoun.capitalize() + " " + "work" + "[u][i]" + P.s_arr[value] + "[/i][/u]" + s_sentence
			get_check_buttons().get(6).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['s'] = value
		"es":
			es_label.text = subjective_pronoun.capitalize() + " " + "do[u][i]" + P.es_arr[value] + "[/i][/u] " + possessive_dep_pronoun + es_sentence
			get_check_buttons().get(7).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['es'] = value
		_:
			printerr("This verb: ", verb ," does not exist.")


func _on_back_button_pressed() -> void:
	# Only call when the pronouns need to be reset.
	#P.clear()
	custom_pronouns.show()
	self.hide()


func _on_visibility_changed() -> void:
	if self.visible:
		%AnimationPlayer.play("blur_bg")
	else:
		%AnimationPlayer.play("RESET")


func _on_confirm_button_pressed() -> void:
	_notification.show()
	custom_pronouns.set_new_keys()
	P._save(custom_pronouns.save_name)
