extends ScrollContainer

onready var button = load("res://assets/button.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_dialogue_options_prompt(dialogue_prompt_text):
	$dialogueOptions/prompt.bbcode_text = dialogue_prompt_text
	
func add_dialogue_option(dialogue_text, function):
	var new_button = button.instance()
	new_button.text = dialogue_text
	connect_function(new_button, function)
	$dialogueOptions.add_child(new_button)

func connect_function(button, function):
	button.connect("pressed", self, function)

