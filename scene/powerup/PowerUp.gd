extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

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
	$PickUpSound.play()
	$ShowTimer.start()
	
func pickup(area):
	set_deferred("monitoring",false)
	$Tween.start()

func _on_ShowTimer_timeout():
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



