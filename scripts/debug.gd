extends Control

var curr_pronoun: String = ""

func _ready() -> void:
	P.curr_pronoun.connect(get_pronoun)

func get_pronoun(pronoun) -> void:
	curr_pronoun = pronoun

func _process(_delta: float) -> void:
	%curr_pronoun.text = "curr_pronoun: " + curr_pronoun
	%are_label.text = P.are
	%were_label.text = P.were
	%s_label.text = P.s
	%custom_pronouns.text = "custom: " + str(P.custom_pronouns.keys())
	
	for i in P.custom_pronouns.keys():
		if P.custom_pronouns[i].has('reflexive'):
			%custom_pronouns_keys.text = P.custom_pronouns[i]['reflexive']
	%player_pronouns.text = "player: " + str(P.player_pronouns.keys())


func _on_print_all_button_pressed() -> void:
	print_rich("[b]All the pronouns:[/b] ", JSON.stringify((P.player_pronouns), "  "))
	print_rich("[b]All the customs:[/b] ", JSON.stringify((P.custom_pronouns), "  "))
