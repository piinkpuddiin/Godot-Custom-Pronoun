extends Control

# TODO: make it work in a text/dialogic setting
# TODO: the custom pronouns just won't delete themselves good lord

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

func _ready() -> void:
	for i in get_line_edits():
		i.editable = false
	line_edits_text_submitted()
	set_defaults()


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
	print(JSON.stringify(Pronouns.player_pronouns[curr_custom_dict], "  "))


# TODO: Set the pronouns in such a way that custom types are their own dict.
func _on_add_button_pressed() -> void:
	var button = Button.new()
	button.toggle_mode = true
	
	#for i in pronoun_choice_hbox.get_children():
		#if i.text.contains("custom_"):
			#@warning_ignore("unassigned_variable_op_assign")
	custom_num += 1
	print("The custom number: ", custom_num)
	
	button.text = "custom_" + str(custom_num)
	button.name = "custom_" + str(custom_num)
	Pronouns.player_pronouns["custom_" + str(custom_num)] = {}
	
	pronoun_choice_hbox.add_child(button)
	await get_tree().process_frame
	pronoun_choice_scroll_container.ensure_control_visible(button)
	button.pressed.connect(check_custom)
	button.pressed.connect(_on_custom_pronoun_button_pressed.bind(button.name))
	button.toggled.connect(line_edits_pronouns.bind(Pronouns.player_pronouns, "custom_" + str(custom_num)))
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
	reflexive_example.text = _pronoun.capitalize() + " will take care of [b]" + new_text + "[/b]."
#endregion


#region DEFAULTS
func _on_custom_pronoun_button_pressed(custom_pronoun: String) -> void:
	check_custom()
	
	for i in get_line_edits():
		i.editable = true
		i.text = ""
	
	delete_button.disabled = false
	curr_custom_dict = custom_pronoun
	curent_pronoun_label.text = custom_pronoun
	print("current dict custom num: ", custom_pronoun)


func set_defaults():
	for i in pronoun_choice_hbox.get_children():
		if i is Button and !i.name.begins_with("custom") and !i.name.begins_with("add"):
			i.toggled.connect(toggle_default_pronouns.bind(i.name.trim_suffix("_button")))
			i.toggled.connect(line_edits_pronouns.bind(Pronouns.default_pronouns,i.name.trim_suffix("_button")))


func toggle_default_pronouns(toggled_on: bool, pronoun: String):
	if toggled_on:
		Pronouns.player_pronouns[pronoun] = Pronouns.default_pronouns[pronoun]
	else:
		if Pronouns.player_pronouns.get(pronoun):
			Pronouns.player_pronouns.erase(pronoun)
	delete_button.disabled = true


func line_edits_pronouns(toggled_on: bool, dict: Dictionary, pronoun: String):
	Pronouns.curr_pronoun.emit(pronoun)
	
	if toggled_on:
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
## If the custom key doesn't exist, we create it.
func check_custom():
	if !Pronouns.player_pronouns.has(curr_custom_dict):
		Pronouns.player_pronouns[curr_custom_dict] = {}
#endregion


func _on_save_button_pressed() -> void:
	pass # Replace with function body.


func _on_print_all_button_pressed() -> void:
	print("All the pronouns: ", JSON.stringify((Pronouns.player_pronouns), "  "))


## ONLY FOR CUSTOM PRONOUNS
func _on_delete_button_pressed() -> void:
	for i in pronoun_choice_hbox.get_children():
		if i.name == curr_custom_dict:
			i.call_deferred("queue_free")
	
	Pronouns.player_pronouns.erase(curr_custom_dict)
	print("Deleted: ", curr_custom_dict)
	curent_pronoun_label.text = ""
	curr_custom_dict = ""
