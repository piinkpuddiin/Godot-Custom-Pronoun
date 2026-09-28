extends Node

signal hide_pronouns

func _ready() -> void:
	Pronouns.loaded_pronouns.connect(load_data)

## The function to load the data from the player's save.
func load_data(save_name):
	Pronouns.player_pronouns = Pronouns._load(save_name).get("pronouns")
	#print(Pronouns.player_pronouns)
	#print("load_data")
