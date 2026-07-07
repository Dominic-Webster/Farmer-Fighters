extends Enemy
class_name Worm

var direction: Vector2 = Vector2.RIGHT


func _physics_process(_delta: float) -> void:
	if direction.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

	velocity = direction * move_speed + knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * _delta)

	move_and_slide()

	if is_on_wall():
		direction.x *= -1
