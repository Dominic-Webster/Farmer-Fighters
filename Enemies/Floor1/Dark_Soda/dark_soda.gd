extends Enemy
class_name DarkSoda

var can_move: bool = false

# Store the last direction to move in while player is dashing
var last_direction: Vector2 = Vector2.ZERO


func _ready():
	super._ready()
	if global_position.x > player.global_position.x:
		sprite.flip_h = true
	anim.play("idle")
	await anim.animation_finished
	anim.play("idle")
	await anim.animation_finished
	if not is_dead:
		can_move = true
		anim.play("move")


func _physics_process(_delta: float) -> void:
	if player == null or not can_move:
		return
	
	var direction = get_chase_direction(player.global_position, _delta)
	var move_velocity
	
	if global_position.x > player.global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	if player.is_dashing:
		# Keep moving in the last known direction
		move_velocity = last_direction * move_speed
	else:
		# Update direction towards player
		last_direction = direction
		move_velocity = last_direction * move_speed
	
	velocity = move_velocity + knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * _delta)
		
	move_and_slide()


func on_player_damaged() -> void:
	if is_dead or not can_move:
		return

	can_move = false
	anim.play("idle")
	await anim.animation_finished
	if not is_dead:
		can_move = true
		anim.play("move")


func die():
	if not is_dead:
		died.emit()
		is_dead = true
		hurt_box.set_deferred("monitoring", false)
		move_speed = 0
		anim.stop()
		anim.play("die")
		await anim.animation_finished
		cherry_shot()
		queue_free()
