extends KinematicBody2D

# Player script based on GDQuests's "Make Your First 2D Game with Godot" Tutorial
export var _player_speed: = Vector2(300.0, 600.0)
export var _player_hp = 200.0
export var gravity = 2000.0
export var light_damage = 10.0
export var heavy_damage = 30.0
#export var scaling = Vector2(2.0, 2.0)

var _player_velocity = Vector2.ZERO
var _player_direction
var _player_sprite
var _player_attacking = false
var _player_getting_hit = false
var _player_dead = false
var _collision_shape

# Variable to ensure damage occurs only once per attack animation
# Hacked in "boss" script
var damage_emitted = false
var death_animation_played = false

# Attack collisions
var attack1_collision_shape
var attack2_collision_shape
# flip_h collision shapes for when character faces left
var attack1_collision_shape_flip_h
var attack2_collision_shape_flip_h

# For is_on_floor()
const FLOOR_NORMAL : = Vector2.UP

func _ready():
	_player_sprite = $AnimatedSprite
	attack1_collision_shape = $AnimatedSprite/attack1hitbox/CollisionShape2D
	attack2_collision_shape = $AnimatedSprite/attack2hitbox/CollisionShape2D
	attack1_collision_shape_flip_h = $AnimatedSprite/attack1hitbox_flip_h/CollisionShape2D
	attack2_collision_shape_flip_h = $AnimatedSprite/attack2hitbox_flip_h/CollisionShape2D
	attack1_collision_shape.disabled = true
	attack2_collision_shape.disabled = true
	attack1_collision_shape_flip_h.disabled = true
	attack2_collision_shape_flip_h.disabled = true

# Called when the node enters the scene tree for the first time.
func _physics_process(dt):
	if not _player_dead:
		player_movement_loop(dt)
	
func _process(dt):
	if _player_dead:
		if not death_animation_played:
			_player_sprite.play("death")
			yield(_player_sprite, "animation_finished")
		_player_sprite.play("dead")
	else:
		player_animation_loop()

func player_movement_loop(dt):
	var jump_interrupted = Input.is_action_just_released("jump") and _player_velocity.y < 0.0
	if not _player_attacking:
		_player_direction = get_direction()
		_player_velocity = calculate_move_velocity(_player_velocity, _player_direction, _player_speed, jump_interrupted)
		_player_velocity = move_and_slide(_player_velocity, FLOOR_NORMAL)
		
		
func player_animation_loop():
	orient_player()
	if Input.is_action_just_pressed("basic_attack"):
		player_attack("basic_attack")
	elif Input.is_action_just_pressed("heavy_attack"):
		player_attack("heavy_attack")
	elif _player_getting_hit:
		_player_sprite.play("get-hit")
		_player_getting_hit = false
	elif not _player_attacking:
		if player_idle():
			_player_sprite.play("idle")
		elif player_jumping():
			_player_sprite.play("jump")
		else:
			_player_sprite.play("run")


func player_idle():
	return _player_velocity == Vector2.ZERO and not _player_attacking

func player_jumping():
	return not is_on_floor()

func orient_player():
	if _player_velocity.x > 0:
		_player_sprite.set_flip_h(false)
	elif _player_velocity.x < 0:
		_player_sprite.set_flip_h(true)

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		jump_interrupted: bool
	) -> Vector2:
	var out := linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	out.y = min(out.y, _player_speed.y)
	# Jumping
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if jump_interrupted:
		out.y = 0.0
	return out

func take_damage(dmg):
	_player_hp -= dmg
	_player_getting_hit = true
	# Cancel any jumping animation
	_player_velocity.y = 0.0
	print(_player_hp)
	if _player_hp <= 0:
		_player_dead = true

func player_attack(attack_type):
	# Only register if not already attacking
	if not _player_attacking:
		_player_attacking = true
		# Cancel any jumping animation
		_player_velocity.y = 0.0
		
		# Register attack
		if attack_type == "basic_attack":
			_player_sprite.play("attack1")
			# Facing right
			if _player_sprite.flip_h:
				attack1_collision_shape_flip_h.disabled = false
			# Facing left
			else:
				attack1_collision_shape.disabled = false
			return light_damage
		elif attack_type == "heavy_attack":
			_player_sprite.play("attack2")
			# Facing right
			if _player_sprite.flip_h:
				attack2_collision_shape_flip_h.disabled = false
			# Facing left
			else:
				attack2_collision_shape.disabled = false
			return heavy_damage
	else:
		pass


func _on_AnimatedSprite_animation_finished():
	if _player_sprite.animation == "attack1" or _player_sprite.animation == "attack2":
		_player_attacking = false
		attack1_collision_shape.disabled = true
		attack2_collision_shape.disabled = true
		attack1_collision_shape_flip_h.disabled = true
		attack2_collision_shape_flip_h.disabled = true
		damage_emitted = false
	if _player_sprite.animation == "death":
		death_animation_played = true
