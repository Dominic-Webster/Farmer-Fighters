extends Enemy
class_name TurretBoss

@onready var shoot_point : Marker2D = $ShootPoint

@export var bullet_scene : PackedScene
@export var action_delay : Vector2 = Vector2(0.2, 0.6)

var is_shooting : bool = false
var action_timer : float = randf_range(action_delay.x, action_delay.y)
var aim_direction : Vector2 = Vector2.UP


func _physics_process(_delta: float) -> void:
	if player == null or is_dead:
		return

	velocity = Vector2.ZERO
	move_and_slide()

	if is_shooting:
		return

	aim_direction = (player.global_position - global_position).normalized()
	if aim_direction != Vector2.ZERO:
		sprite.rotation = aim_direction.angle() + PI / 2

	action_timer -= _delta
	if action_timer <= 0:
		shoot_at_player(aim_direction)


func shoot_at_player(direction: Vector2) -> void:
	if bullet_scene == null or player == null or is_dead:
		return

	if direction == Vector2.ZERO:
		direction = (player.global_position - global_position).normalized()
		if direction == Vector2.ZERO:
			direction = Vector2.UP

	is_shooting = true
	sprite.rotation = direction.angle() + PI / 2

	anim.play("start_shoot")
	await anim.animation_finished

	if is_dead:
		is_shooting = false
		return

	anim.play("end_shoot")

	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	bullet.global_position = global_position + shoot_point.position.rotated(sprite.rotation)
	bullet.direction = direction
	bullet.rotation = sprite.rotation

	await anim.animation_finished

	is_shooting = false
	action_timer = randf_range(action_delay.x, action_delay.y)


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
		
		if RunManager.player_damaged_this_floor == true:
			get_parent().spawn_heart()
		else:
			get_parent().spawn_miniboss_reward(RunManager.current_room)

		# Tell the room to spawn the elevator and handle persistence
		await get_parent().spawn_elevator_at_center()

		queue_free()
