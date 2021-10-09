extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var screensize

# Called when the node enters the scene tree for the first time.
func _ready():
	$Tween.interpolate_property($AnimatedSprite,
	"scale",
	$AnimatedSprite.scale,
	$AnimatedSprite.scale*3,
	0.3,
	Tween.TRANS_QUAD)
	$Tween.interpolate_property($AnimatedSprite,
	"modulate",
	Color(1,1,1,1),
	Color(1,1,1,0),
	1.2,
	Tween.TRANS_QUAD,
	Tween.EASE_IN_OUT)
	$AnimationTimer.wait_time = rand_range(2,5)
	$AnimationTimer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func pickup(area):
	if area.is_in_group("player"):
		set_deferred("monitoring",false)
		$PickUpSound.play()
		$Tween.start()
	else:
		position = Vector2(rand_range(0,screensize.x),rand_range(0,screensize.y))

func _on_Tween_tween_completed(object, key):
	queue_free()

func _on_AnimationTimer_timeout():
	$AnimatedSprite.frame = 0
	$AnimatedSprite.play()
