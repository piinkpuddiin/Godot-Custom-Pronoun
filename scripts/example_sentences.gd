extends Control

# TODO: makin them verbs...
@export var main: Node
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

# TODO: Add the missing verbs...
# TODO: Show sentences on the first showing

func _ready() -> void:
	P.set_sentence.connect(example_sentence)
	P.curr_verb.connect(update_sentence)
	P.curr_pronoun.connect(set_pronoun)
	set_toggle()

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


func set_verb(toggled_on: bool, button: CheckButton, verb: String):
	if toggled_on:
		button.text = "Plural"
		P.curr_verb.emit(verb, "plural")
	else:
		button.text = "Singular"
		P.curr_verb.emit(verb, "singular")

## Set the example sentences once the screen is shown.
func example_sentence() -> void:
	P.player_pronouns[curr_pronoun]['verbs'] = {}
	
	update_sentence("are")
	update_sentence("arent")
	update_sentence("were")
	update_sentence("have")
	update_sentence("do")
	update_sentence("dont")
	update_sentence("s")
	update_sentence("es")
	
	pronoun_label()

func pronoun_label():
	var subjective_pronoun: String = P.player_pronouns[curr_pronoun]['pronouns']['subjective']
	var obbjective_pronoun: String = P.player_pronouns[curr_pronoun]['pronouns']['objective']
	current_pronoun_label.text = (
		"Current pronoun: [b]" + 
		subjective_pronoun.capitalize() + 
		"/" + 
		obbjective_pronoun.capitalize()
	)


func update_sentence(verb: String, _type: String = "singular") -> void:
	var subjective_pronoun: String = P.player_pronouns[curr_pronoun]['pronouns']['subjective']
	var possessive_dep_pronoun: String = P.player_pronouns[curr_pronoun]['pronouns']['possessive_dep']
	
	var value: int = 0
	
	if _type == "singular":
		value = 0
	else:
		value = 1
	
	match verb:
		"are":
			are_label.text = subjective_pronoun.capitalize() + " " + P.are_arr[value] + are_sentence
			P.player_pronouns[curr_pronoun]['verbs']['are'] = ""
			P.player_pronouns[curr_pronoun]['verbs']['are'] = value
		"arent":
			arent_label.text = subjective_pronoun.capitalize() + " " + P.arent_arr[value] + arent_sentence
			P.player_pronouns[curr_pronoun]['verbs']['arent'] = ""
			P.player_pronouns[curr_pronoun]['verbs']['arent'] = value
		"were":
			were_label.text = subjective_pronoun.capitalize() + " " + P.were_arr[value] + were_sentence
			P.player_pronouns[curr_pronoun]['verbs']['were'] = ""
			P.player_pronouns[curr_pronoun]['verbs']['were'] = value
		"have":
			have_label.text = subjective_pronoun.capitalize() + " " + P.have_arr[value] + have_sentence
			P.player_pronouns[curr_pronoun]['verbs']['have'] = ""
			P.player_pronouns[curr_pronoun]['verbs']['have'] = value
		"do":
			do_label.text = P.do_arr[value].capitalize() + " " + subjective_pronoun + do_sentence
			P.player_pronouns[curr_pronoun]['verbs']['do'] = ""
			P.player_pronouns[curr_pronoun]['verbs']['do'] = value
		"dont":
			dont_label.text = P.dont_arr[value].capitalize() + " " + subjective_pronoun + dont_sentence
			P.player_pronouns[curr_pronoun]['verbs']['dont'] = ""
			P.player_pronouns[curr_pronoun]['verbs']['dont'] = value
		"s":
			s_label.text = subjective_pronoun.capitalize() + " " + "work" + P.s_arr[value] + s_sentence
			P.player_pronouns[curr_pronoun]['verbs']['s'] = ""
			P.player_pronouns[curr_pronoun]['verbs']['s'] = value
		"es":
			es_label.text = subjective_pronoun.capitalize() + " " + "do" + P.es_arr[value] + " " + possessive_dep_pronoun + es_sentence
			P.player_pronouns[curr_pronoun]['verbs']['es'] = ""
			P.player_pronouns[curr_pronoun]['verbs']['es'] = value
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
