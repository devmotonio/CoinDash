extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal pickup
signal hurt

export (int) var speed

var MoveTo = Vector2()
var ScreenSize = Vector2(480,720)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	get_input()
	position += MoveTo * delta
	position.x = clamp(position.x,0,ScreenSize.x)
	position.y = clamp(position.y,0,ScreenSize.y)
	
	if MoveTo.length() > 0:
		$AnimatedSprite.animation = "run"
		$AnimatedSprite.flip_h = MoveTo.x < 0
	else:
		$AnimatedSprite.animation = "idle"

func get_input():
	MoveTo = Vector2()
	if Input.is_action_pressed("ui_left"):
		MoveTo.x -= 1
	if Input.is_action_pressed("ui_right"):
		MoveTo.x += 1
	if Input.is_action_pressed("ui_up"):
		MoveTo.y -= 1
	if Input.is_action_pressed("ui_down"):
		MoveTo.y += 1
	if MoveTo.length() > 0:
		MoveTo = MoveTo.normalized() * speed

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
