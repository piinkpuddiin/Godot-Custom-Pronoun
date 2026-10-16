extends Control

@export var pronouns_hbox: HBoxContainer

func _ready() -> void:
	self.hide()
	Dialogic.timeline_started.connect(show)
	Dialogic.timeline_started.connect(add_labels)
	Dialogic.timeline_ended.connect(hide)

func add_labels():
	# Remove the previous pronouns.
	for i in pronouns_hbox.get_children(true):
		i.queue_free()
	
	for i in P.player_pronouns.keys():
		var rtl:= RichTextLabel.new()
		var decoration_text:= Label.new()
		decoration_text.text = "•"
		rtl.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		rtl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		rtl.autowrap_mode = TextServer.AUTOWRAP_OFF
		rtl.fit_content = true
		rtl.text = P.player_pronouns[i]['pronouns']['subjective'].capitalize() + "/" + P.player_pronouns[i]['pronouns']['objective'].capitalize()
		rtl.add_theme_font_size_override("normal_font_size", 28)
		pronouns_hbox.add_child(rtl)
		pronouns_hbox.add_child(decoration_text)
	# Remove the last text decoration.
	pronouns_hbox.get_child(-1).queue_free()
