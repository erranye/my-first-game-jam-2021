extends Control

var dialogue_container
var speaker_name
var speaker_dialogue
var tween
var animating = true

func _ready():
	dialogue_container = $DialogueContainer
	speaker_name = $DialogueContainer/speakerName
	speaker_dialogue = $DialogueContainer/DialogueBox/speakerDialogue
	tween = $DialogueContainer/DialogueBox/Tween
	
	speaker_dialogue.percent_visible = 0

func tween_dialogue():
	# Reset typing animation
	speaker_dialogue.percent_visible = 0
	# Tween interpolate property to change "percent_visible" from 0 to 1 over 2 seconds
	tween.interpolate_property(speaker_dialogue, "percent_visible", 0, 1, 2, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	
func display_all_dialogue():
	tween.stop_all()
	speaker_dialogue.percent_visible = 1

func all_dialogue_visible():
	return speaker_dialogue.percent_visible == 1

func set_speaker_name(new_name):
	speaker_name.text = new_name
	
func set_dialogue_text(text):
	speaker_dialogue.bbcode_text = text
	
func show_text_box():
	dialogue_container.visible = true
	
func hide_text_box():
	dialogue_container.visible = false


