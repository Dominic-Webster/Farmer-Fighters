extends Enemy
class_name BarrelBoss

@onready var shoot_point : Marker2D = $ShootPoint

@export var bullet_scene : PackedScene
@export var wavy_bullet_scene : PackedScene

enum State {
	SHOOT1,
	SHOOT2,
	SHOOT3,
	COOLDOWN
}

var state = State.COOLDOWN
var state_timer = 1.5

@export var action_delay : Vector2 = Vector2(0.5, 1.75)
@export var accuracy : Vector2 = Vector2(-0.075, 0.075)
@export var speed_range : Vector2 = Vector2(500, 650)

var action_timer : float = randf_range(action_delay.x, action_delay.y)

var dead : bool = false


func _ready():
	super._ready()
	scale = Vector2(1.25, 1.25)
	global_position = get_parent().player_spawn_c.global_position


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	
	if !dead:
		match state:
			
			State.SHOOT1:
				velocity = Vector2.ZERO
				move_and_slide()
			
			State.SHOOT2:
				velocity = Vector2.ZERO
				move_and_slide()
			
			State.SHOOT3:
				velocity = Vector2.ZERO
				move_and_slide()
			
			State.COOLDOWN:
				velocity = Vector2.ZERO
				move_and_slide()
				
				state_timer -= _delta
				if state_timer <= 0:
					match randi_range(1, 3):
						1:
							state = State.SHOOT1
							shoot_at_player1()
						2:
							state = State.SHOOT2
							shoot_at_player2()
						3:
							state = State.SHOOT3
							shoot_at_player3()


func shoot_at_player1() -> void:
	if bullet_scene == null or player == null or dead:
		return
	
	anim.play("start_shoot_1")
	
	await anim.animation_finished
	
	anim.play("end_shoot_1")
	if dead:
		return
	
	for i in 6:
		var bullet = bullet_scene.instantiate()
		get_tree().current_scene.add_child(bullet)
		bullet.global_position = shoot_point.global_position
		
		match i:
			0:
				bullet.direction = Vector2(1, 1).normalized()
			1:
				bullet.direction = Vector2(1, -1).normalized()
			2:
				bullet.direction = Vector2(-1, -1).normalized()
			3:
				bullet.direction = Vector2(-1, 1).normalized()
			4:
				bullet.direction = Vector2.LEFT
			5:
				bullet.direction = Vector2.RIGHT
		
		bullet.speed = 1000
		bullet.scale *= 1.5
	
	state = State.COOLDOWN
	state_timer = randf_range(action_delay.x, action_delay.y)


func shoot_at_player2() -> void:
	if bullet_scene == null or player == null or dead:
		return
	
	anim.play("start_shoot_2")
	
	await anim.animation_finished
	
	anim.play("end_shoot_2")
	if dead:
		return
	
	for i in 8:
		var bullet = wavy_bullet_scene.instantiate()
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
		
		bullet.speed = 400
		bullet.scale *= 0.75
	
	state = State.COOLDOWN
	state_timer = randf_range(action_delay.x, action_delay.y)


func shoot_at_player3() -> void:
	if bullet_scene == null or player == null or dead:
		return
	
	anim.play("start_shoot_3")
	
	await anim.animation_finished
	
	anim.play("end_shoot_3")
	if dead:
		return
	
	for i in 4:
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
		
		bullet.speed = 800
		bullet.scale *= 1.5
	
	state = State.COOLDOWN
	state_timer = randf_range(action_delay.x, action_delay.y)



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
