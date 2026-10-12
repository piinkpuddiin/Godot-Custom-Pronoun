extends Node

#NOTE: Watch out for pronoun grammar mistakes...
#TODO: add verbs... like the fucking special ones...
#TODO: mix and match pronouns, technically done
#TODO: add multiple set of custom pronouns (hopefully without the need of a limit.)

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

# Temporarily holds the custom pronouns.
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

## VERBS
## The verbs go from singular to the plural pronoun
var are = ["is", "are"]
var were = ["was", "were"]
var have = ["has", "have"]
var havent = ["hasn't", "haven't"]
var arent = ["isn't", "aren't"]
var do = ["does", "do"]
var dont = ["doesn't", "don't"]
var s = ["s", ""]
var es = ["es", ""]

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
	
	#print("The loaded data: ", load_data)
	return load_data
#endregion
