extends Enemy
class_name Lollipop

@export var start_delay : Vector2 = Vector2(0.25, 0.5)
var start_timer : float = randf_range(start_delay.x, start_delay.y)

# Store the last direction to move in while player is dashing
var last_direction: Vector2 = Vector2.ZERO


func _ready():
	super._ready()
	weight = 2


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	
	if start_timer > 0:
		start_timer -= _delta
		velocity = Vector2.ZERO
	else:
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
		cherry_shot()
		queue_free()
