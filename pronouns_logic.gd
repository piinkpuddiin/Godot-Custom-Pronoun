extends Control

# TODO: make it work in a text/dialogic setting
# TODO: make the gosh darn verbs babes... make em... i believe... graaa
# TODO: save them though... like yknow...

@export var main: Node
@export var save_name: String = "save_1"

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

@export_category("Containers")
@export var line_edit_vbox: VBoxContainer
@export var pronoun_choice_hbox: HBoxContainer
@export var pronoun_choice_scroll_container: ScrollContainer

@export_category("Custom")
@export var curent_pronoun_label: RichTextLabel
@export var delete_button: Button
@export var save_button: Button

var curr_custom_dict: String
var custom_num := 0
var subjective_pronoun: String

func _ready() -> void:
	Pronouns.curr_pronoun.connect(set_curr_pronoun)
	line_edits_editable(false)
	line_edits_text_submitted()
	set_defaults()

#region LINEEDITS
## Return all the line edits.
func get_line_edits() -> Array[LineEdit]:
	var line_array: Array[LineEdit]
	for i in line_edit_vbox.get_children(true):
		if i.get_child_count() >= 1:
			for x in i.get_children():
				if x is LineEdit:
					line_array.append(x)
	return line_array

## Make the line edits editable or not.
func line_edits_editable(value: bool) -> void:
	for i in get_line_edits():
		i.editable = value

func line_edits_clear() -> void:
	for i in get_line_edits():
		i.text = ""

## Submits the text for all the line edits.
func line_edits_text_submitted() -> void:
	for i in get_line_edits():
		var pronoun_type = i.name.trim_suffix("_line_edit")
		i.text_submitted.connect(update_pronouns.bind(pronoun_type))
		i.text_changed.connect(update_pronouns.bind(pronoun_type))
#endregion

# Add the pronoun if it doesn't exit to the dict. Add the pronoun to it's
# respective type.
func update_pronouns(new_text: String, type: String) -> void:
	check_custom()
	Pronouns.player_pronouns[curr_custom_dict][type] = new_text.to_lower()


# TODO: Set the pronouns in such a way that custom types are their own dict.
func _on_add_button_pressed() -> void:
	var button = Button.new()
	button.toggle_mode = true
	
	# Keep adding to the custom dicitionary counter
	custom_num += 1
	
	var custom_key =  "custom_" + str(custom_num)
	button.text = custom_key
	button.name = custom_key
	# Initialize the custom key with no value
	Pronouns.player_pronouns[custom_key] = {}
	
	button.toggled.connect(_toggle_custom_pronoun.bind(custom_key))
	
	pronoun_choice_hbox.add_child(button)
	await get_tree().process_frame
	pronoun_choice_scroll_container.ensure_control_visible(button)
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

func _on_reflexive_line_edit_text_changed(new_text: String, _pronoun = "", _custom = "") -> void:
	reflexive_example.text = subjective_pronoun + " will take care of [b]" + new_text + "[/b]."
#endregion


#region DEFAULTS

## Create the default pronoun buttons and add their functions.
func set_defaults() -> void:
	for i in pronoun_choice_hbox.get_children():
		if i is Button and !i.name.begins_with("custom") and !i.name.begins_with("add"):
			var pronoun = i.name.trim_suffix("_button")
			i.toggled.connect(_toggle_default_pronouns.bind(pronoun))
			i.toggled.connect(line_edits_pronouns.bind(Pronouns.default_pronouns, pronoun))


## Set the current pronoun dict key, and display it on the label.
func set_curr_pronoun(custom_pronoun: String) -> void:
	curr_custom_dict = custom_pronoun
	curent_pronoun_label.text = custom_pronoun.capitalize()


# A helper function for the toggle signal in the custom button
func _toggle_custom_pronoun(toggled_on: bool, custom_pronoun: String) -> void:
	if toggled_on:
		check_custom()
		line_edits_editable(true)
		
		# We disable editing and saving, the pronouns have all already been set.
		delete_button.disabled = false
		save_button.disabled = false
		set_curr_pronoun(custom_pronoun)
	else:
		curent_pronoun_label.text = " "
		curr_custom_dict = ""


## Create the toggle function for the default buttons.
func _toggle_default_pronouns(toggled_on: bool, pronoun: String) -> void:
	if toggled_on:
		Pronouns.player_pronouns[pronoun] = Pronouns.default_pronouns[pronoun]
	else:
		if Pronouns.player_pronouns.get(pronoun):
			Pronouns.player_pronouns.erase(pronoun)
		curent_pronoun_label.text = " "
		curr_custom_dict = ""
	
	line_edits_editable(false)
	delete_button.disabled = true
	save_button.disabled = true


## Sets the line_edit for both the custom and default pronouns.
func line_edits_pronouns(toggled_on: bool, dict: Dictionary, pronoun: String):
	if toggled_on:
		Pronouns.curr_pronoun.emit(pronoun)
		
		for i in get_line_edits():
			if i.name.begins_with("objective"):
				if dict[pronoun].has('objective'):
					i.text = dict[pronoun]['objective'].to_pascal_case()
					_on_objective_line_edit_text_changed(dict[pronoun]['objective'])
			
			elif i.name.begins_with("possessive_dep"):
				if dict[pronoun].has('possessive_dep'):
					i.text = dict[pronoun]['possessive_dep'].to_pascal_case()
					_on_possessive_dep_line_edit_text_changed(dict[pronoun]['possessive_dep'])
				
			elif i.name.begins_with("possessive_indep"):
				if dict[pronoun].has('possessive_indep'):
					i.text = dict[pronoun]['possessive_indep'].to_pascal_case()
					_on_possessive_indep_line_edit_text_changed(dict[pronoun]['possessive_indep'])
			
			elif i.name.begins_with("reflexive"):
				if dict[pronoun].has('reflexive'):
					i.text = dict[pronoun]['reflexive'].to_pascal_case()
					_on_reflexive_line_edit_text_changed(dict[pronoun]['reflexive'], pronoun, curr_custom_dict)
				
			elif i.name.begins_with("subjective"):
				if dict[pronoun].has('subjective'):
					i.text = dict[pronoun]['subjective'].to_pascal_case()
					_on_subjective_line_edit_text_changed(dict[pronoun]['subjective'])
	
	if Pronouns.player_pronouns == {}:
		for i in get_line_edits():
			i.text = ""
#endregion


#region HELPER FUNCS
## Creates a custom key if it already doesn't exists.
func check_custom() -> void:
	if !Pronouns.player_pronouns.has(curr_custom_dict):
		Pronouns.player_pronouns[curr_custom_dict] = {}


## Saves the custom pronouns input.
func _on_save_button_pressed() -> void:
	for i in get_line_edits():
		if i.name.begins_with('subjective'):
			Pronouns.player_pronouns[curr_custom_dict]['subjective'] = i.text
		elif i.name.begins_with('objective'):
			Pronouns.player_pronouns[curr_custom_dict]['objective'] = i.text
		elif i.name.begins_with('possessive_dep'):
			Pronouns.player_pronouns[curr_custom_dict]['possessive_dep'] = i.text
		elif i.name.begins_with('possessive_indep'):
			Pronouns.player_pronouns[curr_custom_dict]['possessive_indep'] = i.text
		elif i.name.begins_with('reflexive'):
			Pronouns.player_pronouns[curr_custom_dict]['reflexive'] = i.text
	
	Pronouns._save(save_name)


func _on_load_button_pressed() -> void:
	Pronouns._load(save_name)
	Pronouns.loaded_pronouns.emit(save_name)


## Prints the current players pronouns.
func _on_print_all_button_pressed() -> void:
	print("All the pronouns: ", JSON.stringify((Pronouns.player_pronouns), "  "))


## Deletes the custom pronoun.
func _on_delete_button_pressed() -> void:
	for i in pronoun_choice_hbox.get_children():
		if i.name == curr_custom_dict:
			i.call_deferred("queue_free")
	
	line_edits_editable(false)
	line_edits_clear() # what is we doing...
	
	Pronouns.player_pronouns.erase(curr_custom_dict)
	print("Deleted: ", curr_custom_dict)
	curent_pronoun_label.text = " "
	curr_custom_dict = ""
#endregion
