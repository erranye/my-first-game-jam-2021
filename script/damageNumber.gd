extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_value(value, travel, duration, spread):
	# From https://kidscancode.org/godot_recipes/ui/floating_text/
	text = value
	var movement = travel.rotated(rand_range(-spread/2,spread/2))
	rect_pivot_offset = rect_size/2
	$Tween.interpolate_property(self, "rect_position", 
			rect_position, rect_position + movement, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "modulate:a",
			1.0, 0.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.interpolate_property(self, "rect_scale", rect_scale*3, rect_scale,
			duration, Tween.TRANS_BACK, Tween.EASE_IN)
	$Tween.start()

func _on_Tween_tween_all_completed():
	queue_free()
