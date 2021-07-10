extends Node
const dialogue_handler = preload("res://script/dialogueHandler.gd")

var scene_name
var scene_dialogue_handler
var scene_dialogue
var dialogue_ui
var go_next_scene = false

func _ready():
	scene_name = get_tree().get_current_scene().get_name()
	print(scene_name)
	scene_dialogue_handler = dialogue_handler.new()
	scene_dialogue = scene_dialogue_handler.load_dialogue("res://dialogue/"+str(scene_name)+".json", scene_name)
	dialogue_ui = $DialogueUI
	# First dialogue
	update_dialogue()
	display_dialogue()

func _process(dt):
	if Input.is_action_just_pressed("ui_accept"):
		if dialogue_ui.all_dialogue_visible():
			update_dialogue()
			if scene_dialogue_handler.dialogue_finished:
				# Scene transition
				print("End scene")
				go_next_scene = true
				get_tree().change_scene('res://scenes/platformScene.tscn')
			else:
				display_dialogue()
		else:
			dialogue_ui.display_all_dialogue()
				
func update_dialogue():
	scene_dialogue_handler.run_dialogue()

func display_dialogue():
	dialogue_ui.set_speaker_name(scene_dialogue_handler.current_speaker)
	dialogue_ui.set_dialogue_text(scene_dialogue_handler.current_speaker_text)
	dialogue_ui.tween_dialogue()
	
	
