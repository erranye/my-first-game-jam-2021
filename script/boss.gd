extends KinematicBody2D

export var total_hp = 1000.0
var current_hp = total_hp

var _boss_sprite
var getting_hit = false
var _death_animation_played = false
var dead = false
var fx
var fade_timer
var fading = false
var attacking = false
var damaging = false
var revving_attack = 0
var revving_timer
var reposition_timer
var first_attack = true
var attack_timer
var swing_damaged = false
var detected_bodies_to_hit

# Called when the node enters the scene tree for the first time.
func _ready():
	_boss_sprite = $AnimatedSprite
	fx = $SpecialEffect
	fade_timer = $fadeTimer
	attack_timer = $attackTimer
	revving_timer = $revvingTimer
	reposition_timer = get_parent().get_node("bossRepositionTimer")
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
		process_attack()
		boss_animation_loop()

func process_attack():
	if _boss_sprite.flip_h:
		detected_bodies_to_hit = $attack2_hitBox_flip_h.get_overlapping_bodies()
	else:
		detected_bodies_to_hit = $attack2_hitBox.get_overlapping_bodies()
	if not fading and detected_bodies_to_hit.size() > 0 and not getting_hit:
		if first_attack and not attacking:
			reposition_timer.set_paused(true)
			randomize()
			# Random 1 or 2
			var attack_i = randi()% 2 + 1
			rev_attack(attack_i)
			attack_timer.set_wait_time(5)
			attack_timer.start()
			first_attack = false
		elif attack_timer.get_time_left() < 1 and not attacking:
			reposition_timer.set_paused(true)
			randomize()
			# Random 1 or 2
			var attack_i = randi()% 2 + 1
			rev_attack(attack_i)
			attack_timer.set_wait_time(4)
			attack_timer.start()

func orient_boss(flip):
	if flip:
		disable_attack_hitboxes()
		enable_attack_flip_h_hitboxes()
	else:
		enable_attack_hitboxes()
		disable_attack_flip_h_hitboxes()


func get_hp_percentage():
	if current_hp > 0:
		return current_hp / total_hp
	else:
		return 0

func death_check():
	if current_hp <= 0:
		dead = true
	
func boss_animation_loop():
	if getting_hit and not attacking:
		_boss_sprite.modulate = Color(1,0,0,0.5)
		_boss_sprite.play("get_hit")
	elif attacking:
		getting_hit = false
	else:
		_boss_sprite.play("idle")

func rev_attack(n):
	attacking = true
	revving_attack = n
	_boss_sprite.play("attack"+str(n))
	_boss_sprite.set_frame(0)
	_boss_sprite.stop()
	revving_timer.set_wait_time(1)
	revving_timer.start()
	$Tween.interpolate_property(self, "modulate", Color(1,1,1,1), Color(1,0.2,0.2,0.8), 1.0,
								Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()


func boss_swing(n):
	_boss_sprite.modulate = Color(1,1,1,1)
	_boss_sprite.play("attack"+str(n))
	damaging = true
	

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
	if attack_type == '1':
		current_hp -= body.light_damage
	elif attack_type == '2':
		current_hp -= body.heavy_damage
	print(current_hp)
	
func _on_AnimatedSprite_animation_finished():
	if _boss_sprite.animation == "get_hit":
		_boss_sprite.modulate = Color(1,1,1,1)
		getting_hit = false
	elif _boss_sprite.animation == "death":
		_death_animation_played = true
		_boss_sprite.playing = false
	elif _boss_sprite.animation == 'attack1' or _boss_sprite.animation == 'attack2':
		attacking = false
		damaging = false
		swing_damaged = false
		reposition_timer.set_paused(false)
		reposition_timer.start(reposition_timer.get_time_left())


func _on_HitBox_area_entered(area):
	#HACKISH DAMAGE SOLUTION
	var player = area.get_parent().get_parent()
	if area.is_in_group("sword") and not player.damage_emitted:
		var attack_type = area.name[6]
		on_hit(player, attack_type)
		player.damage_emitted = true
	
func disable_attack_hitboxes():
	$attack1_hitBox/CollisionShape2D.disabled = true
	$attack2_hitBox/CollisionShape2D.disabled = true

func enable_attack_hitboxes():
	$attack1_hitBox/CollisionShape2D.disabled = false
	$attack2_hitBox/CollisionShape2D.disabled = false

func disable_attack_flip_h_hitboxes():
	$attack1_hitBox_flip_h/CollisionShape2D.disabled = true
	$attack2_hitBox_flip_h/CollisionShape2D.disabled = true

func enable_attack_flip_h_hitboxes():
	$attack1_hitBox_flip_h/CollisionShape2D.disabled = false
	$attack2_hitBox_flip_h/CollisionShape2D.disabled = false
	
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
		
func _on_revvingTimer_timeout():
	boss_swing(revving_attack)
	var bodies_to_damage
	for body in detected_bodies_to_hit:
		if not swing_damaged:
			body.take_damage(50)
			swing_damaged = true
	revving_timer.stop()
