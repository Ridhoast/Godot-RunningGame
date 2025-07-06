#extends Node2D
#
#@export var EnemyScene: PackedScene
#var timer: Timer
#var points := 0
#
#func _ready():
	## Status awal
	#$StatusLabel.text = "GET READY"
#
	## Connect sinyal dari player
	#$Player.connect("collision", Callable(self, "_on_player_collision"))
#
	## Timer untuk spawn musuh
	#timer = Timer.new()
	#timer.wait_time = 2.0
	#timer.one_shot = false
	#timer.timeout.connect(_on_timer_timeout)
	#add_child(timer)
	#timer.start()
#
#func _on_timer_timeout():
	#points += 1
	#$PointsLabel.text = str(points)
	#$StatusLabel.text = ""
#
	#if EnemyScene:
		#var enemy = EnemyScene.instantiate()
		#enemy.name = "enemy"
		#enemy.position = Vector2(1100, 400) 
		#add_child(enemy)
#
#
#func _on_player_collision():
	#print("Player collides!")
	#points -= 1
	#$PointsLabel.text = str(points)

extends Node2D

var enemy_scene = preload("res://Enemy.tscn")
var enemy = preload("res://Enemy.tscn")

var timer
var points = 0
@export var max_enemies := 5  # maksimum musuh yang aktif

func _ready():
	var playerNode = get_tree().get_root().find_child("Player", true, false)
	playerNode.connect("collision", Callable(self, "_on_player_collision"))

	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 4.0
	timer.one_shot = false
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))
	timer.start()

func _on_timer_timeout():
	points += 1

	var pointsLabel = get_tree().get_root().find_child("PointsLabel", true, false)	
	pointsLabel.text = str(points)

	var statusLabel = get_tree().get_root().find_child("StatusLabel", true, false)
	statusLabel.text = ""
	
	var e = enemy.instantiate()
	add_child(e)

	var spawn_side = randi() % 2  # 0 = atas, 1 = kanan

	if spawn_side == 0:
		e.position = Vector2(randi_range(40, 960), 192)
		e.apply_force(Vector2(0, 1000))  # jatuh ke bawah
		e.mass = randf() * 2.0 + 1 
	else:
		e.position = Vector2(1100, 512)
		e.linear_velocity = Vector2(-300, 0)  # geser ke kiri

	# Auto-hilang 2 detik setelah spawn
	await get_tree().create_timer(2.0).timeout
	if is_instance_valid(e):
		e.queue_free()

	#self.add_child(e)


func _on_player_collision():
	print("Game Over!")
	points -= 1
