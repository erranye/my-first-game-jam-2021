extends Control

var dialogue_container
var previous_speaker
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

func set_background_image(path_to_image):
	$CanvasLayer/TextureRect.set_texture(load(path_to_image))

func set_speaker_image(path_to_image):
	$speakerSprite.set_texture(load(path_to_image))

func show_speaker_image():
	$speakerSprite.visible = true

func hide_speaker_image():
	$speakerSprite.visible = false
