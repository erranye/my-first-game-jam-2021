extends Node2D

export var damage = 20
var animating = false
var animator
var animation_timer
var flamelash_complete = false

func _ready():
	animator = $AnimatedSprite
	animation_timer = $Timer
	$FlameWhip/CollisionShape2D.disabled = true


func play_teleport_prep():
	self.set_scale(Vector2(1.5,1.5))
	self.set_z_as_relative(-100)
	animator.play('midnight')
	animating = true
	
func play_teleport_in():
	self.set_scale(Vector2(2,-1.5))
	animator.play('magickhit')
	animating = true
	
func play_teleport_out():
	self.set_scale(Vector2(2,1.5))
	animator.play('magickhit')
	animating = true


func _on_AnimatedSprite_animation_finished():
	if animator.animation == "weaponhit":
		pass
	else:
		if animator.animation == "midnight":
			self.set_z_as_relative(2)
		if animator.animation == "flamelash":
			$FlameWhip/CollisionShape2D.disabled = true
			flamelash_complete = true
	animator.stop()
	animating = false

func play_flame_lash():
	animator.play('weaponhit')
	yield(animator, "animation_finished")
	$FlameWhip/CollisionShape2D.disabled = false
	animator.play('flamelash')
	yield(animator, "animation_finished")
	

func _on_FlameWhip_body_entered(body):
	body.take_damage(damage)
