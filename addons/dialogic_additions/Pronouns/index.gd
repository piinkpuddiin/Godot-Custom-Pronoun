@tool
extends DialogicIndexer

func _get_events() -> Array:
	return [this_folder.path_join('event_pronouns.gd')]

func _get_subsystems() -> Array:
	return [{'name':'Pronouns', 'script':this_folder.path_join('subsystem_pronouns.gd')}]