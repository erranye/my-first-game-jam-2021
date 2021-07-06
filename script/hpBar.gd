extends ProgressBar

onready var label = $Label

func _ready():
	self.percent_visible = false

func update_bar(percentage, display_value):
	self.value = percentage
	$Label.text = str(display_value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
