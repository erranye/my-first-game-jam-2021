extends Node2D

var damage_number = preload("res://assets/damageNumber.tscn")

export var travel = Vector2(0, -80)
export var duration = 0.5
export var spread = PI/2

func show_value(value, crit=false):
	var floating_damage_number = damage_number.instance()
	add_child(floating_damage_number)
	floating_damage_number.show_value(str(value), travel, duration, spread)
