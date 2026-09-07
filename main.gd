extends Control

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

var subject_pronoun: String
var object_pronoun: String
var possessive_dependant_pronoun: String
var possessive_independant_pronoun: String
var reflexive_pronoun: String

func _ready() -> void:
	get_line_edits()

func get_line_edits():
	for i in line_edit_vbox.get_children(true):
		if i.get_child_count() >= 1:
			for x in i.get_children():
				if x is LineEdit:
					#print(x.name)
					#print(x)
					var pronoun_type = x.name.trim_suffix("_line_edit")
					#print(pronoun_type)
					x.text_submitted.connect(update_pronouns.bind(pronoun_type))

func update_pronouns(new_text: String, type: String):
	check_custom()
	Pronouns.player_pronouns['custom'][type] = new_text.to_lower()
	print(Pronouns.player_pronouns['custom'])

#region Line Edits EXAMPLES
func _on_subjective_line_edit_text_changed(new_text: String) -> void:
	#subjective_line_edit.text = subjective_line_edit.text[0].to_upper() + subjective_line_edit.text.substr(1,-1)
	subjective_example.text = "[b]" + new_text.capitalize() + "[/b] did the job."
	reflexive_example.text = new_text.capitalize() + " took charge all by [b]herself[/b]."

func _on_objective_line_edit_text_changed(new_text: String) -> void:
	object_example.text = "Are you talking to [b]" + new_text.to_lower() + "[/b]?"

func _on_possessive_dep_line_edit_text_changed(new_text: String) -> void:
	possessive_dep_example.text = "Working is [b]" + new_text + "[/b] only driving force."

func _on_possessive_indep_line_edit_text_changed(new_text: String) -> void:
	possessive_indep_example.text = "This book is [b]" + new_text + "[/b]."

func _on_reflexive_line_edit_text_changed(new_text: String) -> void:
	if Pronouns.player_pronouns['custom'].get('subjective'):
		var subjective_pronoun = Pronouns.player_pronouns['custom']['subjective']
		reflexive_example.text = subjective_pronoun.capitalize() + " took charge all by [b]" + new_text + "[/b]."
	else:
		reflexive_example.text = "She took charge all by [b]" + new_text + "[/b]."
#endregion

#region DEFAULTS
func _on_custom_pronoun_button_pressed() -> void:
	check_custom()
	#Pronouns.player_pronouns['custom'] = {}
	print(JSON.stringify(Pronouns.player_pronouns, "  "))


func _on_they_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Pronouns.player_pronouns['they'] = Pronouns.default_pronouns['they']
	else:
		if Pronouns.player_pronouns.get("they"):
			Pronouns.player_pronouns.erase('they')
	print(JSON.stringify(Pronouns.player_pronouns, "  "))


func _on_she_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Pronouns.player_pronouns['she'] = Pronouns.default_pronouns['she']
	else:
		if Pronouns.player_pronouns.get("she"):
			Pronouns.player_pronouns.erase('she')
	print(JSON.stringify(Pronouns.player_pronouns, "  "))


func _on_he_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		Pronouns.player_pronouns['he'] = Pronouns.default_pronouns['he']
	else:
		if Pronouns.player_pronouns.get("he"):
			Pronouns.player_pronouns.erase('he')
	print(JSON.stringify(Pronouns.player_pronouns, "  "))

#endregion


#region HELPER FUNCS
func check_custom():
	if !Pronouns.player_pronouns.has('custom'):
		Pronouns.player_pronouns['custom'] = {}
#endregion
