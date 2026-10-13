extends Control

@export var timeline: DialogicTimeline


func start_dialogue() -> void:
	# Check if a dialog is already running
	if Dialogic.current_timeline != null:
		return
	
	Dialogic.start(timeline)


func _on_button_pressed() -> void:
	start_dialogue()
