extends Area2D

export var speed = 1000 # How fast the player will move (pixels/sec).
export var d_spd = 40 # Delta speed

var screen_size # Size of the game window
var velocity = Vector2.ZERO # The player's movement vector
var velocity_to = Vector2.ZERO # The player's movement target vector
var animate = "up" # Movement direction

signal hit

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	
	# (Re-) Enter Screen
	if Input.is_action_just_pressed("enter"):
		velocity = Vector2.ZERO
		velocity_to = Vector2.ZERO
		start(get_viewport_rect().size / 2)
	
	if Input.is_action_just_pressed("full_screen"):
		# Project settings - Strech 2d Ignore
		OS.window_fullscreen = !OS.window_fullscreen
		
	
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


func _on_Player_body_entered(_body):
	hide() # Player disappears after being hit.
	emit_signal("hit")
	# Must be deferred as we can't change physics properties on a physics callback.
	$CollisionShape2D.set_deferred("disabled", true) # Replace with function body.


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
