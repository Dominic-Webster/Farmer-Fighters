extends Enemy
class_name ToxicCow

var dir = Vector2.ZERO
var start_timer : float = 1.0


func _ready() -> void:
	super._ready()
	match randi_range(0, 3):
		0:
			dir = Vector2.UP
		1:
			dir = Vector2.LEFT
		2:
			dir = Vector2.DOWN
		3:
			dir = Vector2.RIGHT


func _physics_process(_delta : float) -> void:
	if player == null:
		return
	
	if dir.x < 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

	if start_timer > 0:
		start_timer -= _delta
		velocity = Vector2.ZERO
	else:
		velocity = dir * move_speed
		move_and_slide()

		if is_on_wall():
			if randi_range(1, 3) == 1:
				dir = (player.global_position - global_position).normalized()
			else:
				dir.x *= -1
				dir.y = 0 + deg_to_rad(randf_range(-30, 30))
				dir = dir.normalized()
		
		if is_on_floor() or is_on_ceiling():
			if randi_range(1, 3) == 1:
				dir = (player.global_position - global_position).normalized()
			else:
				dir.y *= -1
				dir.x = 0 + deg_to_rad(randf_range(-30, 30))
				dir = dir.normalized()


func die():
	if not is_dead:
		died.emit()
		is_dead = true
		hurt_box.set_deferred("monitoring", false)
		move_speed = 0
		anim.stop()
		anim.play("die")
		await anim.animation_finished
		queue_free()
