extends Control

# TODO: Add function to switch between type variations.

@export var main: Node
@export var examples_sentence: Control
@export var save_name: String = "save_1"
@export_enum("LIGHT", "DARK") var theme_type = "LIGHT"

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
@export var example_vbox: VBoxContainer
@export var pronoun_choice_hbox: HBoxContainer
@export var player_pronouns_hbox: HBoxContainer
@export var pronoun_choice_scroll_container: ScrollContainer

@export_category("Misc")
@export var current_pronoun_label: RichTextLabel
@export var delete_button: Button
@export var next_button: Button

var curr_custom_dict: String
## The current pronoun key.
var curr_custom: String
## The number of custom pronoun dict keys.
var custom_num:= 0
var subjective_pronoun: String
## Stores all the original example lines with "___".
var example_labels_array: Array[String]


func _ready() -> void:
	self.hide()
	#check_verb()
	set_defaults()
	line_edits_editable(false)
	P.curr_pronoun.connect(set_curr_pronoun)
	line_edits_text_submitted()
	# Get all the example labels and store them in the array.
	get_example_labels_text()


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

## Clear all the line edits.
func line_edits_clear() -> void:
	for i in get_line_edits():
		i.text = ""

## Submits the text for all the line edits.
func line_edits_text_submitted() -> void:
	for i in get_line_edits():
		var pronoun_type = i.name.trim_suffix("_line_edit")
		# Save all the changes to the correct dict
		i.text_submitted.connect(update_pronouns.bind(pronoun_type))
		i.text_changed.connect(update_pronouns.bind(pronoun_type))
		i.text_changed.connect(check_verb)

## Check every line_edits text to see wheter or not it is empty.
func line_edit_verbs() -> bool:
	var bool_arr: Array[bool]
	
	for i in get_line_edits():
		bool_arr.append(i.text.is_empty())
	
	if bool_arr.count(false) >= 5:
		return false
	else:
		return true

## Check wheter editing the verbs is possible.
func check_verb(_new_text: String = "") -> void:
	await get_tree().process_frame
	
	var filled_arr: Array
	var player_pronouns_arr: Array
	
	P.player_pronouns.erase("")
	# Check if all the types aren't empty.
	for i in P.player_pronouns.keys():
		player_pronouns_arr.append(i)
		for x in P.player_pronouns[i]['pronouns'].keys():
			if !P.player_pronouns[i]['pronouns'][x].is_empty():
				filled_arr.append(false)
			else:
				filled_arr.append(true)
	
	if filled_arr.is_empty():
		next_button.disabled = true
	elif filled_arr.count(true) >= 1:
		next_button.disabled = true
	# We multiply the player_pronuns keys times 5, for the 5 types in the pronouns (subjective, objective, etc...)
	elif filled_arr.count(false) == player_pronouns_arr.size() * 5:
		next_button.disabled = false

#endregion


#region RICHTEXTLABEL
func get_example_labels() -> Array[RichTextLabel]:
	var example_array: Array[RichTextLabel]
	for i in example_vbox.get_children(true):
		if i.get_child_count() >= 1:
			for x in i.get_children():
				if x is RichTextLabel:
					example_array.append(x)
	return example_array

func get_example_labels_text():
	var text_array: Array[String]
	for i in get_example_labels():
		text_array.append(i.text)
	example_labels_array = text_array

## Resets the example lines to the original sentence.
func reset_example_labels():
	for i in get_example_labels():
		i.text = example_labels_array.get(get_example_labels().find(i))
#endregion

#region Line Edits EXAMPLES
func _on_subjective_line_edit_text_changed(new_text: String) -> void:
	subjective_example.text = "[u][i]" + new_text.capitalize() + "[/i][/u] did the job."
	subjective_pronoun = new_text

# Rename the button with it's subjective and/or subjective pronoun from the current pronoun dict key.
func _on_subjective_line_edit_editing_toggled(_toggled_on: bool) -> void:
	set_button_name()

func _on_objective_line_edit_text_changed(new_text: String) -> void:
	object_example.text = "Are you talking to [u][i]" + new_text.to_lower() + "[/i][/u]?"

# Rename the button with it's subjective and/or subjective pronoun from the current pronoun dict key.
func _on_objective_line_edit_editing_toggled(_toggled_on: bool) -> void:
	set_button_name()

func _on_possessive_dep_line_edit_text_changed(new_text: String) -> void:
	possessive_dep_example.text = "Working is [u][i]" + new_text.to_lower() + "[/i][/u] only driving force."

func _on_possessive_indep_line_edit_text_changed(new_text: String) -> void:
	possessive_indep_example.text = "This book is [u][i]" + new_text.to_lower() + "[/i][/u]."

func _on_reflexive_line_edit_text_changed(new_text: String) -> void:
	reflexive_example.text = subjective_pronoun.capitalize() + " will take care of [u][i]" + new_text.to_lower() + "[/i][/u]."

func set_button_name() -> void:
	for i in pronoun_choice_hbox.get_children():
			if i.name == curr_custom_dict:
				if !P.player_pronouns.has(curr_custom_dict):
					return
				elif P.player_pronouns[curr_custom_dict]['pronouns'].has('objective') and P.player_pronouns[curr_custom_dict]['pronouns'].has('subjective'):
					i.text = P.player_pronouns[curr_custom_dict]['pronouns']['subjective'].capitalize() + "/" + P.player_pronouns[curr_custom_dict]['pronouns']['objective'].capitalize()
				elif P.player_pronouns[curr_custom_dict]['pronouns'].has('objective'):
					i.text = P.player_pronouns[curr_custom_dict]['pronouns']['objective'].capitalize()
				elif P.player_pronouns[curr_custom_dict]['pronouns'].has('subjective'):
					i.text = P.player_pronouns[curr_custom_dict]['pronouns']['subjective'].capitalize()
				elif i.text.begins_with("custom_"):
					return
				# Set the current pronoun label to the button name as well.
				current_pronoun_label.text = i.text
#endregion

#region DEFAULTS
## Creates the default pronoun buttons.
func set_defaults() -> void:
	# Remove all the pronoun buttons.
	for i in pronoun_choice_hbox.get_children():
		if i.name.begins_with("add"):
			continue
		i.queue_free()
	
	# Create all the pronoun buttons.
	for i in P.default_pronouns.keys():
		var button:= Button.new()
		var pronoun = i
		button.toggle_mode = true
		button.name = i + "_button"
		button.text = P.default_pronouns[i]['subjective'].capitalize() + "/" + P.default_pronouns[i]['objective'].capitalize()
		button.toggled.connect(_toggle_default_pronouns.bind(pronoun))
		button.toggled.connect(line_edits_pronouns.bind(P.default_pronouns, pronoun))
		# Show the pronouns if the mouse is hovering or the button is focused.
		button.mouse_entered.connect(display_line_edits.bind(pronoun))
		button.focus_entered.connect(display_line_edits.bind(pronoun))
		button.mouse_exited.connect(display_line_edits.bind(pronoun))
		button.focus_exited.connect(display_line_edits.bind(pronoun))
		# Disable editing default pronouns.
		button.focus_entered.connect(line_edits_editable.bind(false))
		button.mouse_entered.connect(line_edits_editable.bind(false))
		
		pronoun_choice_hbox.add_child(button)
		pronoun_choice_hbox.move_child(button, -1)
	
	# Place the add button back at the end of the button list.
	for i in pronoun_choice_hbox.get_children():
		if i.name.begins_with("add"):
			pronoun_choice_hbox.move_child(i, -1)


## Creates a new custom button.
func _on_add_button_pressed() -> void:
	var button = Button.new()
	button.toggle_mode = true
	
	# Keep incrementing to the custom dict counter
	custom_num += 1
	
	var custom_key =  "custom_" + str(custom_num)
	button.text = custom_key
	button.name = custom_key
	
	# Initialize the custom key with no value
	P.custom_pronouns[custom_key] = {}
	P.player_pronouns[custom_key] = {}
	P.player_pronouns[custom_key]['pronouns'] = {}
	
	button.gui_input.connect(delete_custom_event)
	
	button.toggled.connect(_toggle_custom_pronoun.bind(custom_key))
	button.toggled.connect(line_edits_pronouns.bind(P.custom_pronouns, custom_key))
	
	# Show the pronouns on hover/focus.
	button.mouse_entered.connect(display_line_edits.bind(custom_key))
	button.focus_entered.connect(display_line_edits.bind(custom_key))
	# Enable editing custom pronouns.
	button.focus_entered.connect(line_edits_editable.bind(true))
	button.mouse_entered.connect(line_edits_editable.bind(true))
	# Set the custom pronouns dict.
	button.focus_entered.connect(set_curr_pronoun.bind(custom_key))
	button.mouse_entered.connect(set_curr_pronoun.bind(custom_key))
	
	pronoun_choice_hbox.add_child(button)
	await get_tree().process_frame
	pronoun_choice_scroll_container.ensure_control_visible(button)
	pronoun_choice_hbox.move_child(%add_button, -1)
	
	line_edits_editable(false)
	line_edits_clear()


## Set the current pronoun dict key, and display it on the label.
func set_curr_pronoun(custom_pronoun: String) -> void:
	print_rich("The current custom pronoun: [b]", custom_pronoun)
	curr_custom_dict = custom_pronoun
	
	if P.player_pronouns.has(custom_pronoun):
		# NOTE: Could and should be writen with an `and` but it was hard to read. 
		# So two if statments.
		if P.player_pronouns[custom_pronoun]['pronouns'].has('subjective'):
			if  P.player_pronouns[custom_pronoun]['pronouns'].has('objective'):
				current_pronoun_label.text = (
					P.player_pronouns[custom_pronoun]['pronouns']['subjective'].capitalize() +
					 "/" +
					 P.player_pronouns[custom_pronoun]['pronouns']['objective'].capitalize())


## The function for the toggle signal in the custom button.
func _toggle_custom_pronoun(toggled_on: bool, custom_pronoun: String) -> void:
	if toggled_on:
		#check_custom()
		line_edits_editable(true)
		
		if P.custom_pronouns.has(custom_pronoun):
			if !P.player_pronouns.has(custom_pronoun):
				P.player_pronouns[custom_pronoun] = {}
				P.player_pronouns[custom_pronoun]['pronouns'] = P.custom_pronouns[custom_pronoun]
		
		# We disable deleting, the pronouns have all already been set.
		delete_button.disabled = false
		set_curr_pronoun(custom_pronoun)
		display_line_edits(custom_pronoun)
	else:
		# Remove the pronoun key from the player dict. Does not delete the pronoun.
		if P.player_pronouns.has(custom_pronoun):
			P.player_pronouns[custom_pronoun] = {}
			P.player_pronouns.erase(custom_pronoun)
		# Clear the previous pronouns
		line_edits_clear()
		line_edits_editable(false)
		current_pronoun_label.text = " "
		curr_custom_dict = ""


## Create the toggle function for the default buttons.
func _toggle_default_pronouns(toggled_on: bool, default_pronoun: String) -> void:
	if toggled_on:
		check_custom()
		P.player_pronouns[default_pronoun] = {}
		P.player_pronouns[default_pronoun]['pronouns'] = P.default_pronouns[default_pronoun]
	else:
		# Remove the pronoun key from the player dict. Does not delete the pronoun.
		if P.player_pronouns.get(default_pronoun):
			print("Erased pronoun: ", default_pronoun)
			P.player_pronouns.erase(default_pronoun)
		current_pronoun_label.text = " "
		curr_custom_dict = ""
		line_edits_clear()
	display_line_edits(default_pronoun)
	check_verb()
	delete_button.disabled = true


## Sets the line_edit for both the custom and default pronouns button.
func line_edits_pronouns(toggled_on: bool, dict: Dictionary, pronoun: String):
	if !dict.has(pronoun):
		return
	
	if toggled_on:
		P.curr_pronoun.emit(pronoun)
		
		for i in get_line_edits():
			# Don't save empty pronoun lines
			if i.text.is_empty():
				continue
			
			if i.name.begins_with("subjective"):
				if dict[pronoun].has('subjective'):
					i.text = dict[pronoun]['subjective'].to_pascal_case()
					_on_subjective_line_edit_text_changed(dict[pronoun]['subjective'])
			
			elif i.name.begins_with("objective"):
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
					_on_reflexive_line_edit_text_changed(dict[pronoun]['reflexive'])
	
	if P.player_pronouns == {}:
		for i in get_line_edits():
			i.text = ""


## Checks if either of the subjective and objective pronouns exist.[br]
## Returns one of the pronouns or both of them.
func check_pronouns_exist(dict_key: String) -> String:
	var pronouns: String = " "
	if P.player_pronouns[dict_key]['pronouns'].has('subjective') and P.player_pronouns[dict_key]['pronouns'].has('objective'):
		pronouns = P.player_pronouns[dict_key]['pronouns']['subjective'].capitalize() + "/" + P.player_pronouns[dict_key]['pronouns']['objective'].capitalize()
	elif P.player_pronouns[dict_key]['pronouns'].has('subjective'):
		pronouns = P.player_pronouns[dict_key]['pronouns']['subjective'].capitalize()
	elif P.player_pronouns[dict_key]['pronouns'].has('objective'):
		pronouns = P.player_pronouns[dict_key]['pronouns']['objective'].capitalize()
	else:
		pronouns = " "
	
	return pronouns


## Only shows the currently hovered/focused pronouns.
func display_line_edits(pronoun: String):
	# NOTE: Uncomment the line below to keep showing the previously pressed pronoun 
	# if the mouse is hovering/focused over a pronoun that isn't in the player_pronoun dict.
	# We remove the previous pronouns in the line edits.
	line_edits_clear()
	# NOTE: Uncomment the line below to keep showing the previously pressed pronouns examples
	# if the mouse is hovering/focused over a pronoun that isn't in the player_pronoun dict.
	# We the examples sentence labels back to their original example.
	reset_example_labels()
	
	# We only show the pronouns the player has choosen.
	if !P.player_pronouns.has(pronoun):
		# NOTE: Uncomment the line below to keep showing the previously pressed pronoun label
		# even if the mouse is hovering/focused over a pronoun that isn't in the player_pronoun dict.
		current_pronoun_label.text = " "
		return
	
	current_pronoun_label.text = check_pronouns_exist(pronoun)
	
	for i in get_line_edits():
		if i.name.begins_with("subjective"):
			if P.player_pronouns[pronoun]['pronouns'].has('subjective'):
				i.text = P.player_pronouns[pronoun]['pronouns']['subjective'].to_pascal_case()
				_on_subjective_line_edit_text_changed(P.player_pronouns[pronoun]['pronouns']['subjective'])
			
		elif i.name.begins_with("objective"):
			if P.player_pronouns[pronoun]['pronouns'].has('objective'):
				i.text = P.player_pronouns[pronoun]['pronouns']['objective'].to_pascal_case()
				_on_objective_line_edit_text_changed(P.player_pronouns[pronoun]['pronouns']['objective'])
			
		elif i.name.begins_with("possessive_dep"):
			if P.player_pronouns[pronoun]['pronouns'].has('possessive_dep'):
				i.text = P.player_pronouns[pronoun]['pronouns']['possessive_dep'].to_pascal_case()
				_on_possessive_dep_line_edit_text_changed(P.player_pronouns[pronoun]['pronouns']['possessive_dep'])
			
		elif i.name.begins_with("possessive_indep"):
			if P.player_pronouns[pronoun]['pronouns'].has('possessive_indep'):
				i.text = P.player_pronouns[pronoun]['pronouns']['possessive_indep'].to_pascal_case()
				_on_possessive_indep_line_edit_text_changed(P.player_pronouns[pronoun]['pronouns']['possessive_indep'])
			
		elif i.name.begins_with("reflexive"):
			if P.player_pronouns[pronoun]['pronouns'].has('reflexive'):
				i.text = P.player_pronouns[pronoun]['pronouns']['reflexive'].to_pascal_case()
				_on_reflexive_line_edit_text_changed(P.player_pronouns[pronoun]['pronouns']['reflexive'])
	
	if P.player_pronouns == {}:
		for i in get_line_edits():
			i.text = ""
#endregion


# Save all the pronouns to the save.
func _on_save_button_pressed() -> void:
	save_custom_dict()
	P._save(save_name)

# Load the pronouns from the save.
func _on_load_button_pressed() -> void:
	P._load(save_name)

# Prints the current players pronouns.
func _on_print_all_button_pressed() -> void:
	print_rich("[b]All the pronouns:[/b] ", JSON.stringify((P.player_pronouns), "  "))

# Deletes the custom pronoun.
func _on_delete_button_pressed() -> void:
	delete_custom()

func _on_next_button_pressed() -> void:
	# Delete the empty key.
	P.player_pronouns.erase("")
	
	P.curr_pronoun.emit(P.player_pronouns.keys()[0])
	examples_sentence.add_pronouns()
	examples_sentence.show()
	
	self.hide()

#region HELPER FUNCS
## Deletes the hovered/focused custom button.
func delete_custom_event(event: InputEvent) -> void:
	if event.is_action("delete"):
		print("Deleted button!")
		delete_custom()


## Delete the current custom button.
func delete_custom() -> void:
	for i in pronoun_choice_hbox.get_children():
		if i.name == curr_custom_dict:
			i.call_deferred("queue_free")
	
	line_edits_editable(false)
	line_edits_clear()
	check_verb()
	delete_button.disabled = true
	
	print("Deleted pronoun: ", curr_custom_dict)
	P.player_pronouns.erase(curr_custom_dict)
	P.custom_pronouns.erase(curr_custom_dict)
	current_pronoun_label.text = " "
	curr_custom_dict = ""


## Add the pronoun type if it doesn't exist to the dict.
func update_pronouns(new_text: String, type: String) -> void:
	check_custom()
	P.player_pronouns[curr_custom_dict]['pronouns'][type] = new_text.to_lower()
	P.custom_pronouns[curr_custom_dict][type] = new_text.to_lower()


## Creates a custom key if it already doesn't exists.
func check_custom() -> void:
	P.custom_pronouns.erase("")
	P.player_pronouns.erase("")
	
	if !P.player_pronouns.has(curr_custom_dict):
		P.player_pronouns[curr_custom_dict] = {}
		P.player_pronouns[curr_custom_dict]['pronouns'] = {}
	if !P.default_pronouns.has(curr_custom_dict):
		if !P.custom_pronouns.has(curr_custom_dict):
			P.custom_pronouns[curr_custom_dict] = {}


## Saves the custom pronouns input.
func save_custom_dict():
	for i in get_line_edits():
		# Don't save empty pronoun lines
		if i.text.is_empty():
			continue
		
		if i.name.begins_with('subjective'):
			P.player_pronouns[curr_custom_dict]['pronouns']['subjective'] = i.text
		elif i.name.begins_with('objective'):
			P.player_pronouns[curr_custom_dict]['pronouns']['objective'] = i.text
		elif i.name.begins_with('possessive_dep'):
			P.player_pronouns[curr_custom_dict]['pronouns']['possessive_dep'] = i.text
		elif i.name.begins_with('possessive_indep'):
			P.player_pronouns[curr_custom_dict]['pronouns']['possessive_indep'] = i.text
		elif i.name.begins_with('reflexive'):
			P.player_pronouns[curr_custom_dict]['pronouns']['reflexive'] = i.text


## Set the player_pronouns custom_foo keys as their subjective pronoun.
## "custom_1" : {'pronouns': {'subjective': 'doll'}} becomes -> "doll" : {'pronouns': {'subjective': 'doll'}}
func set_new_keys() -> void:
	for i in P.player_pronouns.keys():
		if i.begins_with("custom_"):
			if P.player_pronouns[i]['pronouns'].has('subjective'):
				var new_key: String = P.player_pronouns[i]['pronouns']['subjective'] 
				P.player_pronouns[new_key] = P.player_pronouns[i]
				P.player_pronouns.erase(i)
				print("New keys set: ", P.player_pronouns.keys())


## Clears the screen from the previous choices and resets the custom_num counter.
func clear():
	custom_num = 0
	
	for i in pronoun_choice_hbox.get_children():
		if i.name == curr_custom_dict:
			i.call_deferred("queue_free")
	
	for i in pronoun_choice_hbox.get_children():
		i.button_pressed = false
	
	set_defaults()
	reset_example_labels()
#endregion
