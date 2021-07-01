extends Node
const dialogue_handler = preload("res://script/dialogueHandler.gd")

var scene_name
var scene_dialogue_handler
var scene_dialogue
var dialogue_ui

func _ready():
	scene_name = get_tree().get_current_scene().get_name()
	scene_dialogue_handler = dialogue_handler.new()
	scene_dialogue = scene_dialogue_handler.load_dialogue("res://test.json", scene_name)
	dialogue_ui = $DialogueUI
	update_dialogue()

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if dialogue_ui.all_dialogue_visible():
			if scene_dialogue_handler.dialogue_finished:
				pass
				# Scene transition
			else:
				update_dialogue()
		else:
			dialogue_ui.display_all_dialogue()
				
	

func update_dialogue():
	scene_dialogue_handler.run_dialogue()
	print(scene_dialogue_handler.dialogue_index)
	dialogue_ui.set_speaker_name(scene_dialogue_handler.current_speaker)
	dialogue_ui.set_dialogue_text(scene_dialogue_handler.current_speaker_text)
	dialogue_ui.tween_dialogue()
	
	
