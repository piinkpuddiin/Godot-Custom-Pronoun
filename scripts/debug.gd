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


func _on_print_all_button_pressed() -> void:
	print_rich("[b]All the pronouns:[/b] ", JSON.stringify((P.player_pronouns), "  "))
