extends Enemy
class_name RedChips

@export var jump_speed : float = 250.0
@export var jump_delay : Vector2 = Vector2(0.7, 1.5)

var jumping : bool = false
var jump_direction : Vector2 = Vector2.ZERO
var jump_timer : float = randf_range(jump_delay.x, jump_delay.y)

var dead : bool = false


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	
	# Apply knockback
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * _delta)
	
	# Currently jumping
	if jumping:
		velocity = jump_direction * jump_speed + knockback_velocity
		move_and_slide()
		
		return
	
	# Waiting before next jump
	jump_timer -= _delta
	
	if jump_timer <= 0 and not dead:
		start_jump()


func start_jump() -> void:
	# Store direction at jump start
	jump_direction = (player.global_position - global_position).normalized()
	
	anim.play("start_jump")
	
	jumping = true
	
	anim.play("jump_up")
	
	# Delay before actual movement (wind-up)
	await anim.animation_finished
	
	if dead:
		return
	
	# Move during jump
	await get_tree().create_timer(0.25).timeout
	
	if dead:
		return
	
	anim.play("jump_down")
	
	# Stop moving
	jumping = false
	velocity = Vector2.ZERO
	
	anim.play("end_jump")
	await anim.animation_finished
	
	if dead:
		return
	
	# Wait before next jump
	jump_timer = randf_range(jump_delay.x, jump_delay.y)


func die():
	died.emit()
	dead = true
	jumping = false
	hurt_box.set_deferred("monitoring", false)
	anim.stop()
	anim.play("die")
	await anim.animation_finished
	queue_free()


func flash_red():
	if is_flashing:
		return
	
	is_flashing = true
	sprite.modulate = Color(1.192, 0.0, 0.103, 1.0) # red
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1) # back to normal
	is_flashing = false
