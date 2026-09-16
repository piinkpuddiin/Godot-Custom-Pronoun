extends Node

#NOTE: Watch out for pronoun grammar mistakes...
#TODO: add verbs... like the fucking special ones...
#TODO: mix and match pronouns, technically done
#TODO: add multiple set of custom pronouns (hopefully without the need of a limit.)

signal curr_pronoun(pronoun)

var player_pronouns:= {}

var default_pronouns:= {
	"she": {
		"subjective": "she",
		"objective": "her",
		"possessive_dep": "hers",
		"possessive_indep": "her",
		"reflexive": "herself",
	},
	"he": {
		"subjective": "he",
		"objective": "him",
		"possessive_dep": "him",
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
