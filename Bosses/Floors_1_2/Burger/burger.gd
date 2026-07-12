extends Enemy
class_name Burger

@onready var shoot_point : Marker2D = $ShootPoint

@export var bullet_scene : PackedScene

enum State {
	MOVE,
	SHOOT,
	COOLDOWN
}

var state = State.COOLDOWN
var state_timer = 2.0

@export var action_delay : Vector2 = Vector2(0.5, 1.75)
@export var accuracy : Vector2 = Vector2(-0.075, 0.075)
@export var speed_range : Vector2 = Vector2(500, 650)

var action_timer : float = randf_range(action_delay.x, action_delay.y)

var dead : bool = false

func _physics_process(_delta: float) -> void:
	if player == null:
		return
	
	if !dead:
		match state:
			State.MOVE:
				var direction = (player.global_position - global_position).normalized()
				velocity = direction * move_speed
				move_and_slide()
				
				state_timer -= _delta
				if state_timer <= 0:
					state = State.SHOOT
					sprite.rotation = 0
					shoot_at_player()
			
			State.SHOOT:
				velocity = Vector2.ZERO
				move_and_slide()
			
			State.COOLDOWN:
				velocity = Vector2.ZERO
				move_and_slide()
				
				state_timer -= _delta
				if state_timer <= 0:
					state = State.MOVE
					anim.play("move")
					state_timer = 2.0


func shoot_at_player() -> void:
	if bullet_scene == null or player == null or dead:
		return
	
	anim.play("start_shoot")
	
	await anim.animation_finished
	
	anim.play("end_shoot")
	if dead:
		return
	
	for i in 8:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = shoot_point.global_position
		
		match i:
			0:
				bullet.direction = Vector2.UP
			1:
				bullet.direction = Vector2.RIGHT
			2:
				bullet.direction = Vector2.DOWN
			3:
				bullet.direction = Vector2.LEFT
			4:
				bullet.direction = Vector2(1, 1).normalized()
			5:
				bullet.direction = Vector2(1, -1).normalized()
			6:
				bullet.direction = Vector2(-1, -1).normalized()
			7:
				bullet.direction = Vector2(-1, 1).normalized()
		
		bullet.speed = randf_range(speed_range.x, speed_range.y)
	
	state = State.COOLDOWN
	state_timer = 0.75


func die():
	if not is_dead:
		died.emit()
		is_dead = true
		dead = true
		hurt_box.set_deferred("monitoring", false)
		move_speed = 0
		anim.stop()
		sprite.frame = 0
		anim.play("die")
		await anim.animation_finished
		visible = false
		
		get_parent().spawn_heart()

		# Tell the room to spawn the elevator and handle persistence
		await get_parent().spawn_elevator_at_center()

		queue_free()
