extends Node


func start_game():
	get_tree().change_scene("res://scenes/scene0.tscn")

func skip_to_boss_fight():
	get_tree().change_scene("res://scenes/platformScene.tscn")


func _on_startGame_pressed():
	start_game()

func _on_skipToBossFight_pressed():
	skip_to_boss_fight()
