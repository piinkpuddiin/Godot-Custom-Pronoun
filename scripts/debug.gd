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
	
	for i in P.player_pronouns.keys():
		#print("custom i: ", i)
		if P.player_pronouns[i].has('pronouns'):
			%custom_pronouns_keys.text = "custom reflexive: " + P.player_pronouns[i]['pronouns']['reflexive']
		if P.player_pronouns[i].has('verbs'):
			%custom_pronouns_keys.text = "custom are:" + str(P.player_pronouns[i]['verbs']['are'])
			
	%player_pronouns.text = "player: " + str(P.player_pronouns.keys())
	%dict.text = JSON.stringify((P.player_pronouns), "  ")


func _on_print_all_button_pressed() -> void:
	print_rich("[b]All the pronouns:[/b] ", JSON.stringify((P.player_pronouns), "  "))
	print_rich("[b]All the customs:[/b] ", JSON.stringify((P.custom_pronouns), "  "))
