extends Enemy
class_name DarkSoda

# Store the last direction to move in while player is dashing
var last_direction: Vector2 = Vector2.ZERO


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	
	var direction = (player.global_position - global_position).normalized()
	var move_velocity
	
	if RunManager.player.is_dashing:
		# Keep moving in the last known direction
		move_velocity = last_direction * move_speed
	else:
		# Update direction towards player
		last_direction = direction
		move_velocity = last_direction * move_speed
	
	velocity = move_velocity + knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * _delta)
	
	move_and_slide()


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
