extends KinematicBody2D

export var homing_bomb_lifetime = 5
export var speed = 50
var fx
var collider
var timer
var faded_in = false
var faded_out = false

func _ready():
	timer = $Timer
	timer.set_wait_time(homing_bomb_lifetime)
	timer.start()
	fx = $SpecialEffect
	fx.get_node("BleedingFire/CollisionShape2D").disabled = true
	fx.play_bleeding_fire()
	fade_in()

func fade_in():
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 2.0,
								Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	faded_in = true

func fade_out():
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2.0,
								Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	faded_in = false
	faded_out = true

func _on_Timer_timeout():
	# Disable hitboxes upon fading out
	fx.get_node("BleedingFire/CollisionShape2D").disabled = true
	fade_out()


func _on_Tween_tween_completed(object, key):
	if faded_in:
		fx.get_node("BleedingFire/CollisionShape2D").disabled = false
	elif faded_out:
		$Tween.stop(self)
		queue_free()
