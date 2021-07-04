extends KinematicBody2D

export var total_hp = 100.0

var _boss_sprite
var getting_hit = false
var _death_animation_played = false
var dead = false
var fx
var fade_timer
var fading = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_boss_sprite = $AnimatedSprite
	fx = $SpecialEffect
	fade_timer = $fadeTimer
	fx.play_teleport_in()

func _process(dt):
	death_check()
	if dead:
		disable_hitboxes()
		_boss_sprite.modulate = Color(1,1,1,1)
		if not _death_animation_played:
			_boss_sprite.play("death")
		else:
			_boss_sprite.play("dead")
	else:
		boss_animation_loop()
			
		
func death_check():
	if total_hp <= 0:
		dead = true
	
func boss_animation_loop():
	if not getting_hit or dead:
		_boss_sprite.play("idle")

func reposition(new_position):
	fade_out()
	fx.play_teleport_out()
	yield(fx.get_node("AnimatedSprite"), "animation_finished")
	self.set_position(new_position)
	fx.play_teleport_in()
	fade_in()

func fade_out():
	fade_timer.set_wait_time(2)
	fade_timer.start()
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,1,1,0), 2.0,
								Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	# Disable hitboxes upon fading out
	disable_hitboxes()

func fade_in():
	fading = true
	fade_timer.set_wait_time(1)
	fade_timer.start()
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,0), Color(1,1,1,1), 1.0,
								Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
	
	

func on_hit(body, attack_type):
	getting_hit = true
	_boss_sprite.modulate = Color(1,0,0,0.5)
	_boss_sprite.play("get_hit")
	if attack_type == '1':
		total_hp -= body.light_damage
	elif attack_type == '2':
		total_hp -= body.heavy_damage
	print(total_hp)
	
func _on_AnimatedSprite_animation_finished():
	if _boss_sprite.animation == "get_hit":
		_boss_sprite.modulate = Color(1,1,1,1)
		getting_hit = false
	if _boss_sprite.animation == "death":
		_death_animation_played = true
		_boss_sprite.playing = false


func _on_HitBox_area_entered(area):
	#HACKISH DAMAGE SOLUTION
	var player = area.get_parent().get_parent()
	if area.is_in_group("sword") and not player.damage_emitted:
		var attack_type = area.name[6]
		on_hit(player, attack_type)
		player.damage_emitted = true

func disable_hitboxes():
	$hitBox/CollisionShape2D.disabled = true
	$hitBox_flip_h/CollisionShape2D.disabled = true
	$CollisionShape2D.disabled = true

func enable_hitboxes():
	$hitBox/CollisionShape2D.disabled = false
	$hitBox_flip_h/CollisionShape2D.disabled = false
	$CollisionShape2D.disabled = false


func _on_fadeTimer_timeout():
	$Tween.stop(self)
	if fading:
		fading = false
		# Enable hitboxes once we fade back in
		enable_hitboxes()
