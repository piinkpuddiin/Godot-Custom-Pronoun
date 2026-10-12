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
	Pronouns.set_sentence.connect(example_sentence)
	Pronouns.curr_verb.connect(update_sentence)
	Pronouns.curr_pronoun.connect(set_pronoun)
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
		Pronouns.curr_verb.emit(verb, "plural")
	else:
		button.text = "Singular"
		Pronouns.curr_verb.emit(verb, "singular")

## Set the example sentences once the screen is visible
func example_sentence() -> void:
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
	var subjective_pronoun: String = Pronouns.player_pronouns[curr_pronoun]['subjective']
	var obbjective_pronoun: String = Pronouns.player_pronouns[curr_pronoun]['objective']
	current_pronoun_label.text = (
		"Current pronoun: [b]" + 
		subjective_pronoun.capitalize() + 
		"/" + 
		obbjective_pronoun.capitalize()
	)


func update_sentence(verb: String, _type: String = "singular") -> void:
	var subjective_pronoun: String = Pronouns.player_pronouns[curr_pronoun]['subjective']
	var possessive_dep_pronoun: String = Pronouns.player_pronouns[curr_pronoun]['possessive_dep']
	
	match verb:
		"are":
			if _type == "singular":
				are_label.text = subjective_pronoun.capitalize() + " " + Pronouns.are[0] + are_sentence
			else:
				are_label.text = subjective_pronoun.capitalize() + " " + Pronouns.are[1] + are_sentence
		"arent":
			if _type == "singular":
				arent_label.text = subjective_pronoun.capitalize() + " " + Pronouns.arent[0] + arent_sentence
			else:
				arent_label.text = subjective_pronoun.capitalize() + " " + Pronouns.arent[1] + arent_sentence
		"were":
			if _type == "singular":
				were_label.text = subjective_pronoun.capitalize() + " " + Pronouns.were[0] + were_sentence
			else:
				were_label.text = subjective_pronoun.capitalize() + " " + Pronouns.were[1] + were_sentence
		"have":
			if _type == "singular":
				have_label.text = subjective_pronoun.capitalize() + " " + Pronouns.have[0] + have_sentence
			else:
				have_label.text = subjective_pronoun.capitalize() + " " + Pronouns.have[1] + have_sentence
		"do":
			if _type == "singular":
				do_label.text = Pronouns.do[0].capitalize() + " " + subjective_pronoun + do_sentence
			else:
				do_label.text = Pronouns.do[1].capitalize() + " " + subjective_pronoun + do_sentence
		"dont":
			if _type == "singular":
				dont_label.text = Pronouns.dont[0].capitalize() + " " + subjective_pronoun + dont_sentence
			else:
				dont_label.text = Pronouns.dont[1].capitalize() + " " + subjective_pronoun + dont_sentence
		"s":
			if _type == "singular":
				s_label.text = subjective_pronoun.capitalize() + " " + "work" + Pronouns.s[0] + s_sentence
			else:
				s_label.text = subjective_pronoun.capitalize() + " " + "work" + Pronouns.s[1] + s_sentence
		"es":
			if _type == "singular":
				es_label.text = subjective_pronoun.capitalize() + " " + "do" + Pronouns.es[0] + " " + possessive_dep_pronoun + es_sentence
			else:
				es_label.text = subjective_pronoun.capitalize() + " " + "do" + Pronouns.es[1] + " " + possessive_dep_pronoun + es_sentence
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


func _on_confirm_button_pressed() -> void:
	pass # Replace with function body.
