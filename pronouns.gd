extends Node

#NOTE: Watch out for pronoun grammar mistakes...
#TODO: add verbs...
#TODO: mix and match pronuns, technically done
#TODO: add multiple set of custom pronouns (hopefully without the need of a limit.)

var player_pronouns:= {}

var default_pronouns:= {
	"she": {
		"object": "she",
		"subjective": "her",
		"possessive_independant": "her",
		"possessive_dependant": "hers",
		"reflexive": "herself",
	},
	"he": {
		"object": "he",
		"subjective": "his",
		"possessive_independant": "his",
		"possessive_dependant": "him",
		"reflexive": "himself",
	},
	"they": {
		"object": "they",
		"subjective": "theirs",
		"possessive_independant": "theirs",
		"possessive_dependant": "theirs",
		"reflexive": "themself",
	}
}

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


## Verbs
## The verbs go from singular to plural pronoun

## They are named after the plural form of the verb aside from s/es, since
## you will be writing pronouns as [they] [are] rather than [they] [is].
## So excited to lose brain cells <33

var are = ["is", "are"]
var were = ["was", "were"]
var have = ["has", "have"]
var havent = ["hasn't", "haven't"]
var arent = ["isn't", "aren't"]
var do = ["does", "do"]
var dont = ["doesn't", "don't"]
var s = ["s", ""]
var es = ["es", ""]
