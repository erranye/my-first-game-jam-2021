extends Node2D

var loaded_scene
var scene_index = 0

func _ready():
	change_VN_scene(scene_index)

func _process(dt):
	pass
	
func change_VN_scene(i):
	get_tree().change_scene("res://scenes/scene"+str(i)+".tscn")
	scene_index += 1
