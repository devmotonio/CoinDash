extends Node

export (PackedScene) var Coin
export (int) var Playtime

var Level
var Score
var TimeLeft
var ScreenSize
var Playing = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	ScreenSize = get_viewport().get_visible_rect().size
	$Player.ScreenSize = ScreenSize
	$Player.hide()
	$Hud.game_ready()

func new_game():
	Playing = true
	Level = 1
	Score = 0
	TimeLeft = Playtime
	spawn_coins()
	$Player.start($PlayerStart.position)
	$Player.show()
	$GameTimer.start()

func spawn_coins():
	for i in range(4 + Level):
		var c = Coin.instance()
		$CoinContainer.add_child(c)
		c.screensize = ScreenSize
		c.position = Vector2(rand_range(0,ScreenSize.x),rand_range(0,ScreenSize.y))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Playing and $CoinContainer.get_child_count() == 0:
		Level += 1
		TimeLeft += 5
		spawn_coins()

func _on_GameTimer_timeout():
	TimeLeft -= 1
	$Hud.update_time(TimeLeft)
	if TimeLeft < 0:
		game_over()

func _on_Player_pickup():
	Score += 1
	$Hud.update_score(Score)

func _on_Player_hurt():
	game_over()

func game_over():
	Playing = false
	$GameTimer.stop()
	for coin in $CoinContainer.get_children():
			coin.queue_free()
	$Hud.game_over()
	$Player.die()
