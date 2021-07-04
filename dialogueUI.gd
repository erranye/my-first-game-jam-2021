extends Control

var dialogue_container
var speaker_name
var speaker_dialogue
var tween

var dialogue_scrollbox
var dialogue_options_container
var dialogue_options_prompt
var animating = true

func _ready():
	dialogue_container = $DialogueContainer
	speaker_name = $DialogueContainer/speakerName
	speaker_dialogue = $DialogueContainer/DialogueBox/speakerDialogue
	tween = $DialogueContainer/DialogueBox/Tween
	dialogue_scrollbox = $DialogueOptionsScrollbox
	dialogue_options_container = $DialogueOptionsScrollbox/DialogueOptionsContainer
	dialogue_options_prompt = $DialogueOptionsScrollbox/DialogueOptionsContainer/DialogueOptionsPrompt
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

func show_dialogue_options():
	dialogue_scrollbox.visible = true

func hide_dialogue_options():
	dialogue_scrollbox.visible = false

func set_dialogue_options_prompt(dialogue_prompt_text):
	dialogue_options_prompt.bbcode_text = dialogue_prompt_text
	
func add_dialogue_option(dialogue_text):
	var new_button = Button.new()
	new_button.text = dialogue_text
	dialogue_options_container.add_child(new_button)


func _on_Button_button_up():
	add_dialogue_option('Test!') # Replace with function body.
