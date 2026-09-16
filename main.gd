extends Control

# TODO: make it work in a text/dialogic setting
# TODO: the custom is so buggy + it needs to load the saved dicts into the example slots for view grrr

@export_category("Line Edits")
@export var subjective_line_edit: LineEdit
@export var object_line_edit: LineEdit
@export var possessive_indep_line_edit: LineEdit
@export var possessive_dep_line_edit: LineEdit
@export var reflexive_line_edit: LineEdit

@export_category("Pronoun Examples")
@export var subjective_example: RichTextLabel
@export var object_example: RichTextLabel
@export var possessive_indep_example: RichTextLabel
@export var possessive_dep_example: RichTextLabel
@export var reflexive_example: RichTextLabel

@export_category("Container")
@export var line_edit_vbox: VBoxContainer
@export var pronoun_choice_hbox: HBoxContainer
@export var pronoun_choice_scroll_container: ScrollContainer

var curr_custom_dict: String

func _ready() -> void:
	for i in get_line_edits():
		i.editable = false
	line_edits_text_submitted()
	set_defaults()
	Pronouns.curr_custom.connect(set_curr_dict)

func set_curr_dict(custom_dict):
	curr_custom_dict = custom_dict

func get_line_edits() -> Array[LineEdit]:
	var line_array: Array[LineEdit]
	for i in line_edit_vbox.get_children(true):
		if i.get_child_count() >= 1:
			for x in i.get_children():
				if x is LineEdit:
					line_array.append(x)
	return line_array

func line_edits_text_submitted():
	for i in get_line_edits():
		var pronoun_type = i.name.trim_suffix("_line_edit")
		i.text_submitted.connect(update_pronouns.bind(pronoun_type))


func update_pronouns(new_text: String, type: String):
	check_custom()
	Pronouns.player_pronouns[curr_custom_dict][type] = new_text.to_lower()
	#print(Pronouns.player_pronouns[curr_custom_dict])
	print(JSON.stringify(Pronouns.player_pronouns[curr_custom_dict], "  "))


# TODO: Set the pronouns in such a way that custom types are their own dict.
func _on_add_button_pressed() -> void:
	var button = Button.new()
	button.toggle_mode = true
	var x: int
	
	for i in pronoun_choice_hbox.get_children():
		if i.text.contains("Custom"):
			@warning_ignore("unassigned_variable_op_assign")
			x += 1
	
	button.text = "custom_" + str(x)
	Pronouns.curr_custom.emit("custom_" + str(x))
	
	pronoun_choice_hbox.add_child(button)
	await get_tree().process_frame
	pronoun_choice_scroll_container.ensure_control_visible(button)
	button.pressed.connect(check_custom)
	button.toggled.connect(_on_custom_pronoun_button_toggled.bind(button.text))
	pronoun_choice_hbox.move_child(%add_button, -1)

#region Line Edits EXAMPLES
func _on_subjective_line_edit_text_changed(new_text: String) -> void:
	subjective_example.text = "[b]" + new_text.capitalize() + "[/b] did the job."

func _on_objective_line_edit_text_changed(new_text: String) -> void:
	object_example.text = "Are you talking to [b]" + new_text.to_lower() + "[/b]?"

func _on_possessive_dep_line_edit_text_changed(new_text: String) -> void:
	possessive_dep_example.text = "Working is [b]" + new_text + "[/b] only driving force."

func _on_possessive_indep_line_edit_text_changed(new_text: String) -> void:
	possessive_indep_example.text = "This book is [b]" + new_text + "[/b]."

func _on_reflexive_line_edit_text_changed(new_text: String, pronoun = "", custom = "") -> void:
	if Pronouns.player_pronouns.has(custom):
		if Pronouns.player_pronouns[custom].get('subjective'):
			var subjective_pronoun = Pronouns.player_pronouns[custom]['subjective']
			reflexive_example.text = subjective_pronoun.capitalize() + " took charge all by [b]" + new_text + "[/b]."
	if Pronouns.player_pronouns.has(pronoun):
		reflexive_example.text = Pronouns.player_pronouns[pronoun]['subjective'].capitalize() + " took charge all by [b]" + new_text + "[/b]."
	else:
		reflexive_example.text = "She took charge all by [b]" + new_text + "[/b]."
#endregion

#region DEFAULTS
func _on_custom_pronoun_button_toggled(toggled_on: bool, custom_dict: String) -> void:
	Pronouns.curr_pronoun.emit(custom_dict)
	check_custom()
	if toggled_on:
		for i in get_line_edits():
			i.editable = true
			i.text = ""
	else:
		for i in get_line_edits():
			i.editable = false
	
	#print(JSON.stringify(Pronouns.player_pronouns[custom_dict], "  "))
	#print("current dict custom num: ", custom_dict)
	print("current dict custom num: ", curr_custom_dict)

func set_defaults():
	for i in pronoun_choice_hbox.get_children():
		if i is Button and !i.name.begins_with("custom") and !i.name.begins_with("add"):
			i.toggled.connect(toggle_default_pronouns.bind(i.name.trim_suffix("_button")))
			i.toggled.connect(line_edits_default_pronouns.bind(i.name.trim_suffix("_button")))

func toggle_default_pronouns(toggled_on: bool, pronoun: String):
	if toggled_on:
		Pronouns.player_pronouns[pronoun] = Pronouns.default_pronouns[pronoun]
	else:
		if Pronouns.player_pronouns.get(pronoun):
			Pronouns.player_pronouns.erase(pronoun)
	print(JSON.stringify(Pronouns.player_pronouns, "  "))

func line_edits_default_pronouns(toggled_on: bool, pronoun: String):
	Pronouns.curr_pronoun.emit(pronoun)
	
	if toggled_on:
		for i in get_line_edits():
			if i.name.begins_with("subjective") or i.name.begins_with("possessive_indep"):
				i.text = Pronouns.default_pronouns[pronoun]['subjective'].to_pascal_case()
				_on_subjective_line_edit_text_changed(Pronouns.default_pronouns[pronoun]['subjective'])
				_on_possessive_indep_line_edit_text_changed(Pronouns.default_pronouns[pronoun]['possessive_indep'])
			elif i.name.begins_with("objective"):
				i.text = Pronouns.default_pronouns[pronoun]['objective'].to_pascal_case()
				_on_objective_line_edit_text_changed(Pronouns.default_pronouns[pronoun]['objective'])
			elif i.name.begins_with("possessive_dep"):
				i.text = Pronouns.default_pronouns[pronoun]['possessive_dep'].to_pascal_case()
				_on_possessive_dep_line_edit_text_changed(Pronouns.default_pronouns[pronoun]['possessive_dep'])
			elif i.name.begins_with("reflexive"):
				i.text = Pronouns.default_pronouns[pronoun]['reflexive'].to_pascal_case()
				_on_reflexive_line_edit_text_changed(Pronouns.default_pronouns[pronoun]['reflexive'], pronoun, curr_custom_dict)
			elif i.name.begins_with("subjective"):
				i.text = Pronouns.default_pronouns[pronoun]['subjective'].to_pascal_case()
				_on_subjective_line_edit_text_changed(Pronouns.default_pronouns[pronoun]['subjective'])
	
	if Pronouns.player_pronouns == {}:
		for i in get_line_edits():
			i.text = ""
#endregion


#region HELPER FUNCS
## If the custom key doesn't exist, we create it.
func check_custom():
	if !Pronouns.player_pronouns.has(curr_custom_dict):
		Pronouns.player_pronouns[curr_custom_dict] = {}
#endregion
