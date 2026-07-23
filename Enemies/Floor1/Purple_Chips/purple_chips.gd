extends Enemy
class_name PurpleChips

@onready var shoot_point : Marker2D = $ShootPoint

@export var bullet_scene : PackedScene

@export var action_delay : Vector2 = Vector2(0.1, 2.5)
@export var accuracy : Vector2 = Vector2(-0.05, 0.05)

var action_timer : float = randf_range(action_delay.x, action_delay.y)

var dead : bool = false


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	# Apply knockback only
	#knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 10 * _delta)
	#velocity = knockback_velocity
	move_and_slide()

	# Action timer logic
	action_timer -= _delta
	if action_timer <= 0 and not dead:
		shoot_at_player()
		action_timer = randf_range(action_delay.x, action_delay.y)


func shoot_at_player() -> void:
	if bullet_scene == null or player == null or dead or player.current_health < 1:
		return
	
	anim.play("start_shoot")
	
	await anim.animation_finished
	
	anim.play("end_shoot")
	
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = shoot_point.global_position
	var dir = (player.global_position - shoot_point.global_position).normalized()
	# Add accuracy offset
	var angle_offset = randf_range(accuracy.x, accuracy.y)
	dir = dir.rotated(angle_offset)
	bullet.direction = dir
	
	if RunManager.current_floor == 1:
		bullet.speed -= 100


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
