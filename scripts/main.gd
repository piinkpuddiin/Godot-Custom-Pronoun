extends Node

@export var custom_pronouns: Control
@export var main_menu: Control
@export var animation_player: AnimationPlayer

func _ready() -> void:
	if animation_player:
		animation_player.play("bg_shapes")
	P.loaded_pronouns.connect(load_data)
	Dialogic.timeline_ended.connect(timeline_ended)

## The function to load the data from the player's save.
func load_data(save_name):
	P.player_pronouns = P._load(save_name).get("pronouns")

func timeline_ended():
	main_menu.show()
