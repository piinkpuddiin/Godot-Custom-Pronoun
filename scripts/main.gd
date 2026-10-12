extends Node


func _ready() -> void:
	P.loaded_pronouns.connect(load_data)

## The function to load the data from the player's save.
func load_data(save_name):
	P.player_pronouns = P._load(save_name).get("pronouns")
	#print(P.player_pronouns)
