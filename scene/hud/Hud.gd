extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func update_score(value):
	$MarginContainer/ScoreLabel.text = str(value)
	
func update_time(value):
	$MarginContainer/TimeLabel.text = str(value)

func show_message(text):
	$MessageLabel.text = text
	$MessageLabel.show()
	$MessageTimer.start()

func _on_MessageTimer_timeout():
	$MessageLabel.hide()

func _on_Button_pressed():
	emit_signal("start_game")

func start(Score,TimeLeft):
	update_score(Score)
	update_time(TimeLeft)
	$MessageLabel.hide()
	$StartButton.hide()

func finish():
	show_message("Game Over")
	yield($MessageTimer,"timeout")
	init()
	
func init():
	$StartButton.show()
	$MessageLabel.text = "Coin Dash!"
	$MessageLabel.show()
