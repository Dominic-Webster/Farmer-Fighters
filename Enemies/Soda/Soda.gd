extends Enemy
class_name Soda


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	
	var direction = (player.global_position - global_position).normalized()
	var move_velocity = direction * move_speed
	
	velocity = move_velocity + knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * _delta)
	
	move_and_slide()
