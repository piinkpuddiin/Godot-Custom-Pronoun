extends Node

# TODO: Match the verbs with the correct pronoun, even when randomized...
#NOTE: Watch out for pronoun grammar mistakes.

signal curr_pronoun(pronoun)
signal curr_custom(custom)
signal curr_verb()
signal set_sentence
signal loaded_pronouns

var player_pronouns:= {}

var default_pronouns:= {
	"she": {
		"subjective": "she",
		"objective": "her",
		"possessive_dep": "her",
		"possessive_indep": "hers",
		"reflexive": "herself",
	},
	"he": {
		"subjective": "he",
		"objective": "him",
		"possessive_dep": "his",
		"possessive_indep": "his",
		"reflexive": "himself",
	},
	"they": {
		"subjective": "they",
		"objective": "them",
		"possessive_dep": "their",
		"possessive_indep": "theirs",
		"reflexive": "themselves",
	}
}

# Temporarily holds the custom inputed pronouns.
var custom_pronouns:= {}

var gender_expression:= {
	"neutral": {
		"compliment_1": "Good looking",
	},
	"femme": {
		"compliment_1": "Gorgeous",
	},
	"masc": {
		"compliment_1": "Handsome",
	},
	"custom": {}
}

# The current result of the randomized pronoun
var current_pronoun: String

## For ease of writing.
var they = ""
var them = ""
var their = ""
var theirs = ""
var themselves = ""

## VERBS
## The verbs go from singular to the plural pronoun
# TODO: add the ies verb

## Verb value, 0: singular, 1: plural
var vv: int = 0 

var are = ["is", "are"]
var were = ["was", "were"]
var have = ["has", "have"]
var havent = ["hasn't", "haven't"]
var arent = ["isn't", "aren't"]
var do = ["does", "do"]
var dont = ["doesn't", "don't"]
var s = ["s", ""]
var es = ["es", ""]
# TODO: to properly implement
var ies = ["ies", ""]


func _ready() -> void:
	Dialogic.Text.about_to_show_text.connect(they_randomize)
	Dialogic.Text.about_to_show_text.connect(them_randomize)
	Dialogic.Text.about_to_show_text.connect(their_randomize)
	Dialogic.Text.about_to_show_text.connect(theirs_randomize)
	Dialogic.Text.about_to_show_text.connect(themselves_randomize)
	
	Dialogic.Text.about_to_show_text.connect(randomized_verbs)


func randomized_verbs(_info: Dictionary = {}) -> int:
	if they in player_pronouns.keys():
		if player_pronouns[they]['verbs'].has('are'):
			vv = player_pronouns[they]['verbs']['are']
	print(_info['text'])
	return vv


func they_randomize(_info: Dictionary = {}) -> String:
	var pronoun_arr:= []
	for i in player_pronouns.keys():
		if i == "":
			continue
		pronoun_arr.append(player_pronouns[i]['pronouns']['subjective'])
	pronoun_arr.shuffle()
	they = pronoun_arr.pick_random()
	return they


func them_randomize(_info: Dictionary = {}) -> String:
	var pronoun_arr:= []
	for i in player_pronouns.keys():
		if i == "":
			continue
		pronoun_arr.append(player_pronouns[i]['pronouns']['objective'])
	pronoun_arr.shuffle()
	them = pronoun_arr.pick_random()
	return them


func their_randomize(_info: Dictionary = {}) -> String:
	var pronoun_arr:= []
	for i in player_pronouns.keys():
		if i == "":
			continue
		pronoun_arr.append(player_pronouns[i]['pronouns']['possessive_dep'])
	pronoun_arr.shuffle()
	their = pronoun_arr.pick_random()
	return their


func theirs_randomize(_info: Dictionary = {}) -> String:
	var pronoun_arr:= []
	for i in player_pronouns.keys():
		if i == "":
			continue
		pronoun_arr.append(player_pronouns[i]['pronouns']['possessive_indep'])
	pronoun_arr.shuffle()
	theirs = pronoun_arr.pick_random()
	return theirs


func themselves_randomize(_info: Dictionary= {}) -> String:
	var pronoun_arr:= []
	for i in player_pronouns.keys():
		if i == "":
			continue
		pronoun_arr.append(player_pronouns[i]['pronouns']['reflexive'])
	pronoun_arr.shuffle()
	themselves = pronoun_arr.pick_random()
	return themselves


func capitalize_pronoun() -> void:
	pass


#region SAVE/LOAD

const SAVE_PATH:= "user://"
const FILE_PATH:= "_save.ini"

func _save(save_name: String):
	var config_file:= ConfigFile.new()
	var error
	
	config_file.set_value("Pronouns", "player", player_pronouns)
	error = config_file.save(SAVE_PATH + save_name + FILE_PATH)
	
	if error:
		print("An error happened while saving data: ", error)
	
	print("Succesfully saved! Save: " + save_name + ".")


func _load(save_name: String):
	var config_file := ConfigFile.new()
	var load_data = {}
	var error
	
	error = config_file.load(SAVE_PATH + save_name + FILE_PATH)
	
	if error:
		print("An error happened while loading data: ", error)
		return
	
	var saved_pronouns = config_file.get_value("Pronouns", "player", {})
	load_data['pronouns'] = saved_pronouns
	
	return load_data
#endregion
