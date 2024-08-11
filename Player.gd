extends Area2D

export var speed = 500 # How fast the player will move (pixels/sec).

var screen_size # Size of the game window
var velocity = Vector2.ZERO # The player's movement vector
var animate = "up" # Movement direction

signal hit

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	
	# The player's movement target vector
	var velocity_to = Vector2.ZERO
	
	# (Re-) Enter Screen
	if Input.is_action_just_pressed("enter"):
		velocity = Vector2.ZERO
		velocity_to = Vector2.ZERO
		start(get_viewport_rect().size / 2)
	
	if Input.is_action_just_pressed("full_screen"):
		# Project settings - Strech 2d Ignore
		OS.window_fullscreen = !OS.window_fullscreen
		
	# LERP2 - another LERP physics	
	if Input.is_action_just_pressed("move_right"):
		$AnimatedSprite.flip_h = false
		animate = "right"
	if Input.is_action_pressed("move_right"):
		velocity_to.x = speed
		
	if Input.is_action_just_pressed("move_left"):
		$AnimatedSprite.flip_h = true
		animate = "right"
	if Input.is_action_pressed("move_left"):
		velocity_to.x = -speed
		
	if Input.is_action_just_pressed("move_down"):
		$AnimatedSprite.flip_v = true
		animate = "up"
	if Input.is_action_pressed("move_down"):
		velocity_to.y = speed
		
	if Input.is_action_just_pressed("move_up"):
		$AnimatedSprite.flip_v = false
		animate = "up"
	if Input.is_action_pressed("move_up"):
		velocity_to.y = -speed
		
	velocity = lerp(velocity, velocity_to, delta*4)
		
	if int(velocity.x * delta) != 0 or int(velocity.y * delta) != 0:
		$AnimatedSprite.animation = animate
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 30, screen_size.x - 30)
	position.y = clamp(position.y, 35, screen_size.y - 35)


func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true) # Replace with function body.


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
