extends Area2D

export var speed = 1000 # How fast the player will move (pixels/sec).
export var d_spd = 40 # Delta speed

var screen_size # Size of the game window
var velocity = Vector2.ZERO # The player's movement vector
var velocity_to = Vector2.ZERO # The player's movement half-vector
var animate = "up" # Movement direction

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	
	if Input.is_action_just_pressed("full_screen"):
		OS.window_fullscreen = !OS.window_fullscreen
		# Project settings - Strech 2d Ignore
		screen_size = get_viewport_rect().size
		print (screen_size.x)
	
	if Input.is_action_just_pressed("move_right"):
		$AnimatedSprite.flip_h = false
		animate = "right"
	if Input.is_action_pressed("move_right"):
		velocity.x = min(velocity.x + speed/d_spd, speed)
		
	if Input.is_action_just_pressed("move_left"):
		$AnimatedSprite.flip_h = true
		animate = "right"
	if Input.is_action_pressed("move_left"):
		velocity.x = max(velocity.x - speed/d_spd, -speed)
		
	if Input.is_action_just_pressed("move_down"):
		$AnimatedSprite.flip_v = true
		animate = "up"
	if Input.is_action_pressed("move_down"):
		velocity.y = min(velocity.y + speed/d_spd, speed)
		
	if Input.is_action_just_pressed("move_up"):
		$AnimatedSprite.flip_v = false
		animate = "up"
	if Input.is_action_pressed("move_up"):
		velocity.y = max(velocity.y - speed/d_spd, -speed)
		
	velocity_to = Vector2(int(velocity.x/d_spd),int(velocity.y/d_spd))
	velocity = lerp(velocity, velocity_to, delta*4)
		
	if int(velocity.x/d_spd) != 0 or int(velocity.y/d_spd) != 0:
		$AnimatedSprite.animation = animate
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.stop()
	
	position += velocity * delta
	position.x = clamp(position.x, 30, screen_size.x - 30)
	position.y = clamp(position.y, 35, screen_size.y - 35)
	
