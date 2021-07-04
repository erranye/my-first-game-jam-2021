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
	assert(file.file_exists(file_path))
	
	file.open(file_path, file.READ)
	dialogue = parse_json(file.get_as_text())[scene_name]
	assert(dialogue.size() > 0)
	max_dialogue_index = dialogue.size()
	return dialogue


func run_dialogue():
	# Iterate to max_dialogue_index - 1 to account for scene metadata in json
	if dialogue_index < max_dialogue_index - 1:
		current_speaker = dialogue[str(dialogue_index)]['name']
		current_speaker_text = dialogue[str(dialogue_index)]['text']
	else:
		dialogue_active = false
		dialogue_finished = true
	dialogue_index += 1
