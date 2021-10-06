extends Area2D
signal pickup
signal hurt

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
export (int) var speed

var move_to = Vector2()
var screensize = Vector2(480,720)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	position += move_to * delta
	position.x = clamp(position.x,0,screensize.x)
	position.y = clamp(position.y,0,screensize.y)
	
	if move_to.length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = move_to.x < 0
	else:
		$AnimatedSprite.animation = "idle"

func get_input():
	move_to = Vector2()
	if Input.is_action_pressed("ui_left"):
		move_to.x -= 1
	if Input.is_action_pressed("ui_right"):
		move_to.x += 1
	if Input.is_action_pressed("ui_up"):
		move_to.y -= 1
	if Input.is_action_pressed("ui_down"):
		move_to.y += 1
	if move_to.length() > 0:
		move_to = move_to.normalized() * speed

func _on_Player_area_entered(area):
	if area.is_in_group("coins"):
		area.pickup()
		emit_signal("pickup")
	if area.is_in_group("obstacles"):
		emit_signal("hurt")

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"

func die():
	$AnimatedSprite.animation = "hurt"
	set_process(false)
