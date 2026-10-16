extends Control

@export var pronouns_vbox: VBoxContainer

func _ready() -> void:
	self.hide()
	Dialogic.timeline_started.connect(add_labels)
	Dialogic.timeline_ended.connect(hide)

func add_labels():
	for i in  P.player_pronouns.keys():
		var rtl: RichTextLabel = RichTextLabel.new()
		rtl.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		rtl.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		rtl.fit_content = true
		rtl.text = P.player_pronouns[i]['pronouns']['subjective'].capitalize() + "/" + P.player_pronouns[i]['pronouns']['objective'].capitalize()
		rtl.add_theme_font_size_override("normal_font_size", 28)
		pronouns_vbox.add_child(rtl)
