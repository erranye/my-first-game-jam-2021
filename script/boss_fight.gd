extends Node2D
var flamelash = load("res://assets/flamelash.tscn")

var boss_positions
var num_boss_positions
var boss_reposition_timer
var boss_reposition_time = 8
var boss_reposition_time_countdown = boss_reposition_time
var player
var boss
var previous_boss_position
var new_boss_position

# Called when the node enters the scene tree for the first time.
func _ready():
	boss_positions = []
	boss = $boss
	for position in $boss_positions.get_children():
		boss_positions.append(position.get_position())
	boss_reposition()
	boss_reposition_timer = $bossRepositionTimer
	boss_reposition_timer.set_wait_time(boss_reposition_time_countdown)
	boss_reposition_timer.start()
		

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
	spawn_flame_lashes()

func spawn_flame_lashes():
	for child in $flamelash_positions.get_children():
		var spawn_position = child.get_position()
		var new_flamelash = flamelash.instance()
		new_flamelash.set_position(spawn_position)
		add_child(new_flamelash)

func reset_boss_reposition_timer():
	boss_reposition_timer.set_wait_time(boss_reposition_time_countdown)
	boss_reposition_timer.start()
	
func _on_bossRepositionTimer_timeout():
	if not boss.dead:
		boss_reposition()
		reset_boss_reposition_timer()
