extends Node

export (PackedScene) var Coin
export (PackedScene) var PowerUp
export (PackedScene) var Cactus
export (int) var Playtime

var level = 0
var score = 0
var timeleft = 0
var screensize = Vector2()
var playing = false

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	screensize = get_viewport().get_visible_rect().size
	$Player.init(screensize)
	$Hud.init()

func new_game():
	playing = true
	level = 1
	score = 0
	timeleft = Playtime
	$Hud.start(score,timeleft)
	$Player.start($PlayerStart.position)
	spawn_coins()
	spawn_cactus()
	$StartSound.play()
	$GameTimer.start()
	$PowerUpTimer.start()

func spawn_cactus():
	var stop = rand_range(3,9)
	for i in range(stop):
		var c = Cactus.instance()
		c.position = Vector2(rand_range(0,screensize.x),rand_range(0,screensize.y))
		$CactusContainer.add_child(c)

func spawn_coins():
	for i in range(4 + level):
		var c = Coin.instance()
		c.screensize = screensize
		c.position = Vector2(rand_range(0,screensize.x),rand_range(0,screensize.y))
		$CoinContainer.add_child(c)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if playing and $CoinContainer.get_child_count() == 0:
		level += 1
		timeleft += 5
		spawn_coins()

func _on_GameTimer_timeout():
	timeleft -= 1
	$Hud.update_time(timeleft)
	if timeleft < 0:
		game_over()

func _on_Player_pickup(type):
	match type:
		"coin":
			score += 1
			$Hud.update_score(score)
		"powerup":
			timeleft += 5
		_:
			print("default")

func game_over():
	$EndSound.play()
	playing = false
	$GameTimer.stop()
	$PowerUpTimer.stop()
	for coin in $CoinContainer.get_children():
		coin.queue_free()
	for cactus in $CactusContainer.get_children():
		cactus.queue_free()
	$Hud.finish()
	$Player.finish()

func _on_PowerUpTimer_timeout():
	var p = PowerUp.instance()
	add_child(p)
	p.position = Vector2(rand_range(0,screensize.x),rand_range(0,screensize.y))
	$PowerUpTimer.wait_time = rand_range(5,10)
	$PowerUpTimer.start()
