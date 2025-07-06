extends RigidBody2D

func _ready():
	rotation_degrees = randi() % 360

func _integrate_forces(state):
	if position.x < -100 or position.y > 900:
		queue_free()
