extends CharacterBody2D

var speed := -150
func _integrate_forces(state):
	position.x -= 150 * state.get_step()
	if position.x < -100:
		queue_free()
