extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal pickup(type)
signal hurt

export (int) var speed

var moveto = Vector2()
var screensize = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	position += moveto * delta
	position.x = clamp(position.x,0,screensize.x)
	position.y = clamp(position.y,0,screensize.y)
	
	if moveto.length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = moveto.x < 0
	else:
		$AnimatedSprite.animation = "idle"

func get_input():
	moveto = Vector2()
	if Input.is_action_pressed("ui_left"):
		moveto.x -= 1
	if Input.is_action_pressed("ui_right"):
		moveto.x += 1
	if Input.is_action_pressed("ui_up"):
		moveto.y -= 1
	if Input.is_action_pressed("ui_down"):
		moveto.y += 1
	if moveto.length() > 0:
		moveto = moveto.normalized() * speed

func _on_Player_area_entered(area):
	if area.is_in_group("coin"):
		emit_signal("pickup","coin")
	if area.is_in_group("powerup"):
		emit_signal("pickup","powerup")
	if area.is_in_group("obstacle"):
		emit_signal("hurt")

func start(pos):
	set_process(true)
	position = pos
	$AnimatedSprite.animation = "idle"
	show()

func finish():
	$AnimatedSprite.animation = "hurt"
	set_process(false)
	
func init(paramscreensize):
	screensize = paramscreensize
	self.scale = Vector2(1,1)
	$AnimatedSprite.scale = Vector2(1,1)
	hide()
