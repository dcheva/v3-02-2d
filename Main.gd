extends Node2D

export var score = 0
export(PackedScene) var mob_scene

func _ready():
	# Init
	$"StartPosition".position = get_viewport_rect().size / 2
	$"StartPosition".position.y -= 50
	randomize()

func new_game():
	score = 0
	$MobTimer.wait_time = 1 # reser LERP countdown
	get_tree().call_group("mobs", "queue_free")
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$Player.hide()
	$HUD.show_game_over()

func _on_ScoreTimer_timeout():
	score += 1
	$MobTimer.wait_time = lerp($MobTimer.wait_time, 0, 0.01)
	$HUD.update_score(score)
	# @TODO SHOW LEVEL
	print($MobTimer.wait_time)
	
func _on_StartTimer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_MobTimer_timeout():
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instance()
	# Choose a random location on Path2D.
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.offset = randi()
	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2
	# Set the mob's position to a random location.
	mob.position = mob_spawn_location.position
	# Add some randomness to the direction.
	direction += rand_range(-PI / 4, PI / 4)
	mob.rotation = direction
	# Choose the velocity for the mob.
	var velocity = Vector2(rand_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	# Spawn the mob by adding it to the Main scene.
	add_child(mob)

func _on_Player_hit():
	game_over() # Replace with function body.

func _on_Player_restart():
	game_over() 
