extends Control

@export var main: Node
@export var dialogue: Node
@export var pronouns: Node
@export var vbox_container: VBoxContainer

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

var curr_pronoun: String
@export var custom_pronouns: VBoxContainer


func _ready() -> void:
	#check_buttons_disabled()
	P.set_sentence.connect(example_sentence)
	P.curr_verb.connect(update_sentence)
	P.curr_pronoun.connect(set_pronoun)
	set_toggle()


func add_pronouns() -> void:
	# Clear the previous buttons.
	if custom_pronouns.get_child_count() >= 0:
		for i in custom_pronouns.get_children():
			i.queue_free()
	
	for i in P.player_pronouns.keys():
		if P.player_pronouns[i]['pronouns'].has('subjective'):
			print("All the pronouns: ", i)
			var button:= Button.new()
			button.text = P.player_pronouns[i]['pronouns']['subjective'] + "/" + P.player_pronouns[i]['pronouns']['objective']
			button.name = button.text
			
			button.tree_entered.connect(P.set_sentence.emit)
			button.pressed.connect(pronoun_label)
			
			# Set the current pronoun to the hovered/focused button.
			button.focus_entered.connect(set_pronoun.bind(i))
			button.focus_exited.connect(set_pronoun.bind(i))
			button.mouse_exited.connect(set_pronoun.bind(i))
			button.mouse_entered.connect(set_pronoun.bind(i))
			
			# Check the pronoun verbs of the current pronoun.
			button.focus_entered.connect(check_pronoun_verbs)
			button.focus_exited.connect(check_pronoun_verbs)
			button.mouse_exited.connect(check_pronoun_verbs)
			button.mouse_entered.connect(check_pronoun_verbs)
			
			#button.focus_entered.connect(check_buttons_disabled)
			#button.focus_exited.connect(check_buttons_disabled)
			#button.mouse_entered.connect(check_buttons_disabled)
			#button.mouse_exited.connect(check_buttons_disabled)
			
			custom_pronouns.add_child(button)


# Returns the most recent pronoun key
func set_pronoun(pronoun):
	curr_pronoun = pronoun


func get_check_buttons() -> Array[CheckButton]:
	var check_array: Array
	for i in vbox_container.get_children(true):
		for x in i.get_child(0).get_child(0).get_children():
			if x is CheckButton:
				check_array.append(x)
	return check_array


func get_label_examples() -> Array[Label]:
	var label_array: Array
	for i in vbox_container.get_children(true):
		for x in i.get_child(0).get_child(0).get_children():
			if x is RichTextLabel:
				label_array.append(x)
	return label_array


func set_toggle() -> void:
	for i in get_check_buttons():
		var verb = i.name.trim_suffix("_button")
		i.toggled.connect(set_verb.bind(i, verb))

## Check in the 
#func check_buttons_disabled() -> void:
	#for i in get_check_buttons():
		#if curr_pronoun == "":
			#i.disabled = true
		#else:
			#i.disabled = false

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
	if P.player_pronouns[curr_pronoun].has('verbs'):
		update_sentence(curr_pronoun, "are", P.player_pronouns[curr_pronoun]['verbs']['are'])
		update_sentence(curr_pronoun, "arent", P.player_pronouns[curr_pronoun]['verbs']['arent'])
		update_sentence(curr_pronoun, "were", P.player_pronouns[curr_pronoun]['verbs']['were'])
		update_sentence(curr_pronoun, "have", P.player_pronouns[curr_pronoun]['verbs']['have'])
		update_sentence(curr_pronoun, "do", P.player_pronouns[curr_pronoun]['verbs']['do'])
		update_sentence(curr_pronoun, "dont", P.player_pronouns[curr_pronoun]['verbs']['dont'])
		update_sentence(curr_pronoun, "s", P.player_pronouns[curr_pronoun]['verbs']['s'])
		update_sentence(curr_pronoun, "es", P.player_pronouns[curr_pronoun]['verbs']['es'])


## Set the example sentences once the screen is shown.
func example_sentence() -> void:
	pronoun_label()
	for i in P.player_pronouns.keys():
		update_sentence(i, "are")
		update_sentence(i, "arent")
		update_sentence(i, "were")
		update_sentence(i, "have")
		update_sentence(i, "do")
		update_sentence(i, "dont")
		update_sentence(i, "s")
		update_sentence(i, "es")


func pronoun_label():
	var subjective_pronoun: String 
	var objective_pronoun: String
	
	if P.player_pronouns.has(curr_pronoun):
		subjective_pronoun = P.player_pronouns[curr_pronoun]['pronouns']['subjective']
		objective_pronoun = P.player_pronouns[curr_pronoun]['pronouns']['objective']
	current_pronoun_label.text = (
		"Current pronoun: [b]" + 
		subjective_pronoun.capitalize() + 
		"/" + 
		objective_pronoun.capitalize()
	)


func update_sentence(pronoun: String, verb: String, value: int = 0) -> void:
	var subjective_pronoun: String
	var possessive_dep_pronoun: String
	
	if P.player_pronouns[pronoun]['pronouns'].has('subjective'):
		subjective_pronoun = P.player_pronouns[pronoun]['pronouns']['subjective']
		possessive_dep_pronoun = P.player_pronouns[pronoun]['pronouns']['possessive_dep']
	
	#for i in get_check_buttons():
		#pass
	var pressed: bool
	if value == 0:
		pressed = false
	else:
		pressed = true
	
	match verb:
		"are":
			are_label.text = subjective_pronoun.capitalize() + " " + P.are_arr[value] + are_sentence
			get_check_buttons().get(0).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['are'] = ""
			P.player_pronouns[pronoun]['verbs']['are'] = value
		"arent":
			arent_label.text = subjective_pronoun.capitalize() + " " + P.arent_arr[value] + arent_sentence
			get_check_buttons().get(1).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['arent'] = ""
			P.player_pronouns[pronoun]['verbs']['arent'] = value
		"were":
			were_label.text = subjective_pronoun.capitalize() + " " + P.were_arr[value] + were_sentence
			get_check_buttons().get(2).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['were'] = ""
			P.player_pronouns[pronoun]['verbs']['were'] = value
		"have":
			have_label.text = subjective_pronoun.capitalize() + " " + P.have_arr[value] + have_sentence
			get_check_buttons().get(3).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['have'] = ""
			P.player_pronouns[pronoun]['verbs']['have'] = value
		"do":
			do_label.text = P.do_arr[value].capitalize() + " " + subjective_pronoun + do_sentence
			get_check_buttons().get(4).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['do'] = ""
			P.player_pronouns[pronoun]['verbs']['do'] = value
		"dont":
			dont_label.text = P.dont_arr[value].capitalize() + " " + subjective_pronoun + dont_sentence
			get_check_buttons().get(5).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['dont'] = ""
			P.player_pronouns[pronoun]['verbs']['dont'] = value
		"s":
			s_label.text = subjective_pronoun.capitalize() + " " + "work" + P.s_arr[value] + s_sentence
			get_check_buttons().get(6).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['s'] = ""
			P.player_pronouns[pronoun]['verbs']['s'] = value
		"es":
			es_label.text = subjective_pronoun.capitalize() + " " + "do" + P.es_arr[value] + " " + possessive_dep_pronoun + es_sentence
			get_check_buttons().get(7).button_pressed = pressed
			P.player_pronouns[pronoun]['verbs']['es'] = ""
			P.player_pronouns[pronoun]['verbs']['es'] = value
		_:
			print("This verb does not exist.")
			pass


func _on_back_button_pressed() -> void:
	self.hide()


func _on_visibility_changed() -> void:
	if self.visible:
		%AnimationPlayer.play("blur_bg")
	else:
		%AnimationPlayer.play("RESET")


func _on_timeline_test_button_pressed() -> void:
	dialogue.start_dialogue()
	pronouns.set_new_keys()
