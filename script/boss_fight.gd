extends Node2D
var flamelash = load("res://assets/flamelash.tscn")
var bleedingfire = load("res://assets/bleedingfire.tscn")

var boss_positions
var num_boss_positions
var boss_reposition_timer
var boss_reposition_time = 8
var boss_reposition_time_countdown = boss_reposition_time
var player
var boss
var previous_boss_position
var new_boss_position
var homing_bombs = false
var homing_spawn_timer
# Phase 1
# Phase 2: boss 75% hp
# Phase 3: boss 50% hp
# Phase 4: boss 25% hp
var phase = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	boss_positions = []
	player = $player
	boss = $boss
	boss.orient_boss(false)
	for position in $boss_positions.get_children():
		boss_positions.append(position.get_position())
	boss_reposition()
	boss_reposition_timer = $bossRepositionTimer
	boss_reposition_timer.set_wait_time(boss_reposition_time_countdown)
	boss_reposition_timer.start()
	homing_spawn_timer = Timer.new()
	homing_spawn_timer.connect("timeout", self, "_on_homing_spawn_timer_timeout")
	add_child(homing_spawn_timer)
	homing_spawn_timer.start()
		
func process(dt):
	if boss.get_hp_percentage() > 0.5 and boss.get_hp_percentage < 0.75:
		set_phase(2)
	elif boss.get_hp_percentage() > 0.25 and boss.get_hp_percentage < 0.5:
		set_phase(3)
	elif boss.get_hp_percentage() > 0 and boss.get_hp_percentage < 0.25:
		set_phase(4)
	else: 
		pass

func boss_reposition():
	randomize()
	var index_to_teleport_to = randi() % boss_positions.size()
	# Store current position
	previous_boss_position = boss.get_position()
	boss_positions.append(previous_boss_position)
	new_boss_position = boss_positions[index_to_teleport_to]
	
	# Remove destination position to prevent repeat teleportation
	for pos in boss_positions:
		if pos == new_boss_position:
			boss_positions.erase(pos)
	
	# Move boss
	boss.reposition(new_boss_position)
	#Flip boss if past halfway across screen
	if new_boss_position.x > OS.get_window_size().x / 2:
		boss._boss_sprite.flip_h = true
		boss.orient_boss(true)
	else:
		boss._boss_sprite.flip_h = false
		boss.orient_boss(false)
	spawn_ground_flame_lashes(index_to_teleport_to)
	spawn_bleeding_fire()

func spawn_bleeding_fire():
	var new_bleeding_fire = bleedingfire.instance()
	new_bleeding_fire.set_position(boss.get_position())
	add_child(new_bleeding_fire)

#func update_homing_bomb(bomb):
#	bomb.look_at(player.get_position())
#	var bomb_direction = bomb.get_position() - player.get_position()
#	bomb.move_and_slide(bomb_direction * bomb.speed)

func spawn_ground_flame_lashes(index):
	if index % 2 == 0:
		for child in $ground_flamelash_positions_set_2.get_children():
			var spawn_position = child.get_position()
			spawn_flame_lash(spawn_position)
	else:
		for child in $ground_flamelash_positions_set_1.get_children():
			var spawn_position = child.get_position()
			spawn_flame_lash(spawn_position)

func spawn_flame_lash(spawn_position):
	var new_flamelash = flamelash.instance()
	new_flamelash.set_position(spawn_position)
	add_child(new_flamelash)

func spawn_homing_flame_lash():
	spawn_flame_lash(player.get_position())
	
func reset_homing_spawn_timer():
	homing_spawn_timer.set_wait_time(2)
	homing_spawn_timer.start()
	
func reset_boss_reposition_timer():
	boss_reposition_timer.set_wait_time(boss_reposition_time_countdown)
	boss_reposition_timer.start()

func _on_homing_spawn_timer_timeout():
	if not boss.dead:
		spawn_homing_flame_lash()
		reset_homing_spawn_timer()
	
func _on_bossRepositionTimer_timeout():
	if not boss.dead:
		boss_reposition()
		reset_boss_reposition_timer()

func set_phase(n):
	phase = n
