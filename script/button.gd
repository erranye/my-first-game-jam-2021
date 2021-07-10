extends Button

# Declare member variables here. Examples:
var function
var function_args

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_function(new_function):
	function = new_function

func _button_pressed():
	print("Pressed")
