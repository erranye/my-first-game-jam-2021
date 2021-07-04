extends Node2D

var fx
var collider

func _ready():
	fx = $SpecialEffect
	fx.play_flame_lash()

func _process(dt):
	if fx.flamelash_complete:
		queue_free()


