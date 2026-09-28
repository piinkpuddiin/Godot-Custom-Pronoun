extends Control

@export var main: Node
@export var vbox_container: VBoxContainer

@export_category("Sentences")
@export var are_sentence = " running in the woods."
@export var arent_sentence = " walking to class."
@export var were_sentence = " aware of the extent of the damage."
@export var have_sentence = " run out of time."
@export var do_sentence = " like coffee?"
@export var dont_sentence = " like candy?"
@export_category("RichTextLabel")
@export var are_label: RichTextLabel
@export var arent_label: RichTextLabel
@export var were_label: RichTextLabel
@export var have_label: RichTextLabel
@export var do_label: RichTextLabel
@export var dont_label: RichTextLabel

# TODO: Add the missing verbs...
# TODO: Show sentences on the first load/boot up.

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Pronouns.curr_verb.connect(update_sentence)
	set_toggle()


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


func update_sentence(verb: String, _type: String) -> void:
	var subjective_pronoun: String = Pronouns.player_pronouns['custom_1']['subjective']
	
	match verb:
		"are":
			if _type == "plural":
				are_label.text = subjective_pronoun.capitalize() + " " + Pronouns.are[0] + are_sentence
			else:
				are_label.text = subjective_pronoun.capitalize() + " " + Pronouns.are[1] + are_sentence
		"arent":
			if _type == "plural":
				arent_label.text = subjective_pronoun.capitalize() + " " + Pronouns.arent[0] + arent_sentence
			else:
				arent_label.text = subjective_pronoun.capitalize() + " " + Pronouns.arent[1] + arent_sentence
		"were":
			if _type == "plural":
				were_label.text = subjective_pronoun.capitalize() + " " + Pronouns.were[0] + were_sentence
			else:
				were_label.text = subjective_pronoun.capitalize() + " " + Pronouns.were[1] + were_sentence
		"have":
			if _type == "plural":
				have_label.text = subjective_pronoun.capitalize() + " " + Pronouns.have[0] + have_sentence
			else:
				have_label.text = subjective_pronoun.capitalize() + " " + Pronouns.have[1] + have_sentence
		"do":
			if _type == "plural":
				do_label.text = Pronouns.do[0].capitalize() + " " + subjective_pronoun + do_sentence
			else:
				do_label.text = Pronouns.do[1].capitalize() + " " + subjective_pronoun + do_sentence
		"dont":
			if _type == "plural":
				dont_label.text = Pronouns.dont[0].capitalize() + " " + subjective_pronoun + dont_sentence
			else:
				dont_label.text = Pronouns.dont[1].capitalize() + " " + subjective_pronoun + dont_sentence
		_:
			pass
