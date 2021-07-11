class_name DialogueHandler

var dialogue
var dialogue_active = true
var dialogue_finished = false
var dialogue_index = 0
var max_dialogue_index

var current_speaker
var current_speaker_text

func load_dialogue(file_path, scene_name) -> Dictionary:
	"""
	Parse JSON, return dictionary.
	"""
	var file = File.new()
#	assert(file.file_exists(file_path))

	file.open(file_path, file.READ)
	dialogue = parse_json(file.get_as_text())[scene_name] 
	assert(dialogue.size() > 0)
	max_dialogue_index = dialogue.size()
	return dialogue

func run_dialogue():
	if dialogue_index < max_dialogue_index:
		if dialogue[str(dialogue_index)]['type'] == "display":
			current_speaker = dialogue[str(dialogue_index)]['speaker']
			current_speaker_text = dialogue[str(dialogue_index)]['text']
	else:
		dialogue_active = false
		dialogue_finished = true
	dialogue_index += 1

func get_dialogue_index():
	return dialogue_index

func get_current_speaker():
	return current_speaker
