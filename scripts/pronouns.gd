extends Node

# NOTE: Watch out for pronoun grammar mistakes.

signal curr_pronoun(pronoun)
signal curr_custom(custom)
# Emitted to set the proper verb to the current pronoun
signal curr_verb()
# Emitted once the verbs button is clicked.
signal set_sentence
# Emitted once the pronouns have been loaded.
signal loaded_pronouns

# Stores all the pronouns and the pronouns correct verbs.
var player_pronouns:= {}

# The default pronouns, need to match the ones in the custom_pronouns hbox.
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

# TODO: To finish.
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
## The verbs array go from singular to the plural pronoun
var are = ""
var are_arr = ["is", "are"]

var arent = ""
var arent_arr = ["isn't", "aren't"]

var were = ""
var were_arr = ["was", "were"]

var have = ""
var have_arr = ["has", "have"]

var havent = ""
var havent_arr = ["hasn't", "haven't"]

var do = ""
var do_arr = ["does", "do"]

var dont = ""
var dont_arr = ["doesn't", "don't"]

var s = ""
var s_arr = ["s", ""]

var es = ""
var es_arr = ["es", ""]


func _ready() -> void:
	Dialogic.Text.about_to_show_text.connect(they_randomize)
	Dialogic.Text.about_to_show_text.connect(them_randomize)
	Dialogic.Text.about_to_show_text.connect(their_randomize)
	Dialogic.Text.about_to_show_text.connect(theirs_randomize)
	Dialogic.Text.about_to_show_text.connect(themselves_randomize)
	
	Dialogic.Text.about_to_show_text.connect(randomized_are)
	Dialogic.Text.about_to_show_text.connect(randomized_arent)
	Dialogic.Text.about_to_show_text.connect(randomized_were)
	Dialogic.Text.about_to_show_text.connect(randomized_have)
	Dialogic.Text.about_to_show_text.connect(randomized_havent)
	Dialogic.Text.about_to_show_text.connect(randomized_do)
	Dialogic.Text.about_to_show_text.connect(randomized_dont)
	Dialogic.Text.about_to_show_text.connect(randomized_s)
	Dialogic.Text.about_to_show_text.connect(randomized_es)


func clear() -> void:
	for i in player_pronouns.keys():
		player_pronouns.erase(i)
	player_pronouns = {}


#region VERBS functions
func randomized_are(_info: Dictionary = {}) -> String:
	if they in player_pronouns.keys():
		if player_pronouns[they]['verbs'].has('are'):
			are = are_arr[player_pronouns[they]['verbs']['are']]
	return are

func randomized_arent(_info: Dictionary = {}) -> String:
	if they in player_pronouns.keys():
		if player_pronouns[they]['verbs'].has('arent'):
			arent = arent_arr[player_pronouns[they]['verbs']['arent']]
	return arent

func randomized_dont(_info: Dictionary = {}) -> String:
	if they in player_pronouns.keys():
		if player_pronouns[they]['verbs'].has('dont'):
			dont = dont_arr[player_pronouns[they]['verbs']['dont']]
	#print("The don't verb: ",dont)
	return dont

func randomized_were(_info: Dictionary = {}) -> String:
	if they in player_pronouns.keys():
		if player_pronouns[they]['verbs'].has('dont'):
			were = were_arr[player_pronouns[they]['verbs']['were']]
	return dont

func randomized_have(_info: Dictionary = {}) -> String:
	if they in player_pronouns.keys():
		if player_pronouns[they]['verbs'].has('dont'):
			have = dont_arr[player_pronouns[they]['verbs']['have']]
	return have

func randomized_havent(_info: Dictionary = {}) -> String:
	if they in player_pronouns.keys():
		if player_pronouns[they]['verbs'].has('havent'):
			havent = havent_arr[player_pronouns[they]['verbs']['havent']]
	return havent

func randomized_do(_info: Dictionary = {}) -> String:
	if they in player_pronouns.keys():
		if player_pronouns[they]['verbs'].has('do'):
			do = do_arr[player_pronouns[they]['verbs']['do']]
	return do

func randomized_s(_info: Dictionary = {}) -> String:
	if they in player_pronouns.keys():
		if player_pronouns[they]['verbs'].has('s'):
			s = s_arr[player_pronouns[they]['verbs']['s']]
	return s

func randomized_es(_info: Dictionary = {}) -> String:
	if they in player_pronouns.keys():
		if player_pronouns[they]['verbs'].has('es'):
			es = es_arr[player_pronouns[they]['verbs']['es']]
	return es
#endregion

# TODO add seed to make certain pronouns appear moe often than others.

#region PRONOUNS functons
func they_randomize(_info: Dictionary = {}) -> String:
	var pronoun_arr:= []
	for i in player_pronouns.keys():
		if i == "":
			continue
		if player_pronouns[i]['pronouns'].has('subjective'):
			pronoun_arr.append(player_pronouns[i]['pronouns']['subjective'])
	pronoun_arr.shuffle()
	they = pronoun_arr.pick_random()
	return they


func them_randomize(_info: Dictionary = {}) -> String:
	var pronoun_arr:= []
	for i in player_pronouns.keys():
		if i == "":
			continue
		if player_pronouns[i]['pronouns'].has('objective'):
			pronoun_arr.append(player_pronouns[i]['pronouns']['objective'])
	pronoun_arr.shuffle()
	them = pronoun_arr.pick_random()
	return them


func their_randomize(_info: Dictionary = {}) -> String:
	var pronoun_arr:= []
	for i in player_pronouns.keys():
		if i == "":
			continue
		if player_pronouns[i]['pronouns'].has('possessive_dep'):
			pronoun_arr.append(player_pronouns[i]['pronouns']['possessive_dep'])
	pronoun_arr.shuffle()
	their = pronoun_arr.pick_random()
	return their


func theirs_randomize(_info: Dictionary = {}) -> String:
	var pronoun_arr:= []
	for i in player_pronouns.keys():
		if i == "":
			continue
		if player_pronouns[i]['pronouns'].has('possessive_indep'):
			pronoun_arr.append(player_pronouns[i]['pronouns']['possessive_indep'])
	pronoun_arr.shuffle()
	theirs = pronoun_arr.pick_random()
	return theirs


func themselves_randomize(_info: Dictionary= {}) -> String:
	var pronoun_arr:= []
	for i in player_pronouns.keys():
		if i == "":
			continue
		if player_pronouns[i]['pronouns'].has('reflexive'):
			pronoun_arr.append(player_pronouns[i]['pronouns']['reflexive'])
	pronoun_arr.shuffle()
	themselves = pronoun_arr.pick_random()
	return themselves
#endregion


#region SAVE/LOAD
const SAVE_PATH:= "user://"
const FILE_PATH:= "_save.ini"

# An example on how to save the players pronouns.
func _save(save_name: String):
	var config_file:= ConfigFile.new()
	var error
	
	# Everything is stored in the `players_pronouns` dict.
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
