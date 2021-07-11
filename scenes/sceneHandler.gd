extends Node
const dialogue_handler = preload("res://script/dialogueHandler.gd")

var scene_name
var scene_number
var scene_dialogue_handler
var scene_dialogue
var dialogue_ui
var go_next_scene = false

func _ready():
	scene_name = get_tree().get_current_scene().get_name()
	scene_number = int(get_tree().get_current_scene().get_name()[5])
	scene_dialogue_handler = dialogue_handler.new()
	scene_dialogue = scene_dialogue_handler.load_dialogue("res://dialogue/"+str(scene_name)+".json", scene_name)
	dialogue_ui = $DialogueUI
	dialogue_ui.set_background_image("assets/backgrounds/" + scene_name + ".png")
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
				scene_number += 1 
				if scene_number < 10:
					get_tree().change_scene('res://scenes/scene' + str(scene_number) + '.tscn')
				else:
					get_tree().change_scene("res://scenes/platformScene.tscn")
			else:
				display_dialogue()
		else:
			dialogue_ui.display_all_dialogue()
				
func update_dialogue():
	scene_dialogue_handler.run_dialogue()
	if dialogue_ui.get_node("speakerSprite").visible:
		modulate_speaker()
	# Scene 5 boss
	if scene_number == 5:
		if scene_dialogue_handler.get_dialogue_index() == 7:
			dialogue_ui.set_speaker_image("res://assets/sprites/bossVN/Boss (Lycoris).png")
			dialogue_ui.show_speaker_image()
		if scene_dialogue_handler.get_dialogue_index() == 17:
			dialogue_ui.hide_speaker_image()
	# Scene 6 magician
	if scene_number == 6:
		if scene_dialogue_handler.get_dialogue_index() == 9:
			dialogue_ui.set_speaker_image("res://assets/sprites/evilWizardVN/Sprite male mage A curious01.png")
			dialogue_ui.get_node("speakerSprite").modulate.a = 0.8
			dialogue_ui.show_speaker_image()
		if scene_dialogue_handler.get_dialogue_index() == 13:
			dialogue_ui.hide_speaker_image()
	# Scene 7 magician
	if scene_number == 7:
		if scene_dialogue_handler.get_dialogue_index() == 8:
			dialogue_ui.set_speaker_image("res://assets/sprites/evilWizardVN/Sprite male mage A curious01.png")
			dialogue_ui.get_node("speakerSprite").modulate.a = 0.8
			dialogue_ui.show_speaker_image()
		if scene_dialogue_handler.get_dialogue_index() == 21:
			dialogue_ui.hide_speaker_image()
	# Scene 8 boss
	if scene_number == 8:
		if scene_dialogue_handler.get_dialogue_index() == 6:
			dialogue_ui.set_speaker_image("res://assets/sprites/bossVN/Boss (Lycoris).png")
			dialogue_ui.show_speaker_image()
		if scene_dialogue_handler.get_dialogue_index() == 12:
			dialogue_ui.set_speaker_image("res://assets/sprites/evilWizardVN/Sprite male mage A curious01.png")
			dialogue_ui.get_node("speakerSprite").modulate.a = 0.8
			dialogue_ui.show_speaker_image()
		if scene_dialogue_handler.get_dialogue_index() == 21:
			dialogue_ui.hide_speaker_image()
	if scene_number == 9:
		if scene_dialogue_handler.get_dialogue_index() == 6:
			dialogue_ui.set_speaker_image("res://assets/sprites/evilWizardVN/Sprite male mage A curious01.png")
			dialogue_ui.get_node("speakerSprite").modulate.a = 0.8
			dialogue_ui.show_speaker_image()

func modulate_speaker():
	if scene_dialogue_handler.get_current_speaker() == "Me":
		dialogue_ui.get_node("speakerSprite").modulate.a = 0.7
	elif scene_dialogue_handler.get_current_speaker() == "Boss":
		dialogue_ui.get_node("speakerSprite").modulate.a = 1.0
	else:
		dialogue_ui.get_node("speakerSprite").modulate.a = 0.8
					
func display_dialogue():
	dialogue_ui.set_speaker_name(scene_dialogue_handler.current_speaker)
	dialogue_ui.set_dialogue_text(scene_dialogue_handler.current_speaker_text)
	dialogue_ui.tween_dialogue()
	
	
