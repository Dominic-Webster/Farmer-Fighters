extends Enemy
class_name NuggetBoss

@export var start_delay : Vector2 = Vector2(0.2, 0.4)
var start_timer : float = randf_range(start_delay.x, start_delay.y)

var switch_time : Vector2 = Vector2(0.4, 0.7)
var switch_timer : float = 0.5
var direction : Vector2 = Vector2.ZERO

var rng = RandomNumberGenerator.new()


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	
	if start_timer > 0:
		start_timer -= _delta
		return
	
	switch_timer -= _delta
	if switch_timer <= 0:
		switch_timer = randf_range(switch_time.x, switch_time.y)
		match randi_range(1, 4):
			1:
				direction = Vector2.UP
			2:
				direction = Vector2.DOWN
			3:
				direction = Vector2.RIGHT
			4:
				direction = Vector2.LEFT
		#direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
		# Prevent zero direction
		if direction == Vector2.ZERO:
			direction = Vector2(1, 0)
	
	var move_velocity = direction * move_speed
	
	if RunManager.player.global_position.x < global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	velocity = move_velocity + knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * _delta)
	
	move_and_slide()
	
	if is_on_wall():
		direction *= -1


const ElevatorScene = preload("res://scenes/Elevator/Elevator.tscn")

func die():
	if not is_dead:
		died.emit()
		is_dead = true
		hurt_box.set_deferred("monitoring", false)
		move_speed = 0
		anim.stop()
		anim.play("die")
		await anim.animation_finished
		visible = false
		
		RunManager.spawn_heart()

		# Tell the room to spawn the elevator and handle persistence
		await get_parent().spawn_elevator_at_center()

		queue_free()
