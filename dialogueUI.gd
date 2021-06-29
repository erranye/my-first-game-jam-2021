extends Control

onready var dialogue_container = $DialogueContainer
onready var speaker_name = $DialogueContainer/speakerName
onready var speaker_dialogue = $DialogueContainer/DialogueBox/speakerDialogue


func set_speaker_name(new_name):
	speaker_name.text = new_name
	
func set_dialogue_text(text):
	speaker_dialogue.bbcode_text = text


