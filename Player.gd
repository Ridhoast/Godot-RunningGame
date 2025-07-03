extends CharacterBody2D

signal collision

const UP = Vector2.UP
const GRAVITY = 2000
const JUMPFORCE = -800

func _physics_process(delta):
	# Loncat
	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMPFORCE * 1

	# Gerak kanan & kiri (opsional)
	if Input.is_key_pressed(KEY_RIGHT) and is_on_floor():
		velocity.x += 10
	elif Input.is_key_pressed(KEY_LEFT) and is_on_floor():
		velocity.x -= 10
	else:
		velocity.x = 0  # reset horizontal movement

	# Gravitasi
	velocity.y += GRAVITY * delta

	# Setel properti gerak
	set_up_direction(UP)
	set_floor_stop_on_slope_enabled(false)
	set_max_slides(4)
	set_floor_max_angle(0.78)

	# Gerakkan
	move_and_slide()

	# Cek tabrakan
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider().name == "enemy":
			$AnimatedSprite2D.play("hurt")
			emit_signal("collision")
			return

	# Animasi
	if not is_on_floor():
		$AnimatedSprite2D.play("jump")
	elif abs(velocity.x) > 0:
		$AnimatedSprite2D.play("walk")
	elif abs(velocity.x) < 0:
		$AnimatedSprite2D.play("walk_left")
	else:
		$AnimatedSprite2D.play("idle")
