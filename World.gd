extends Node2D

@export var EnemyScene: PackedScene  # drag and drop Enemy.tscn via editor
var timer: Timer
var points := 0

func _ready():
	# Status awal
	$StatusLabel.text = "GET READY"

	# Connect sinyal dari player
	$Player.connect("collision", Callable(self, "_on_player_collision"))

	# Timer untuk spawn musuh
	timer = Timer.new()
	timer.wait_time = 2.0
	timer.one_shot = false
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	timer.start()

func _on_timer_timeout():
	points += 1
	$PointsLabel.text = str(points)
	$StatusLabel.text = ""

	if EnemyScene:
		var enemy = EnemyScene.instantiate()
		enemy.name = "enemy"
		enemy.position = Vector2(1100, 400)  # jangan pakai randf dulu kalau bingung
		add_child(enemy)


func _on_player_collision():
	print("Player collides!")
	points -= 1
	$PointsLabel.text = str(points)
	# Bisa tambahin efek lainnya juga
