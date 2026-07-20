extends Enemy
class_name CandyCorn

enum State { RANDOM_MOVE, CHARGE_UP, CHARGING, WAIT }
var state = State.RANDOM_MOVE
var state_timer = 0.0
var random_move_time = 1.5
var wait_time = 0.1
var charge_speed = 1000
var charge_direction = Vector2.ZERO
var rng = RandomNumberGenerator.new()

var random_dir = Vector2.ZERO
var random_move_switches = 0
var random_move_max_switches = 3

var charge_timer = 0.0
var charge_duration = 0.75

func _ready():
	if not enemy_data == null:
		max_health = enemy_data.health
		damage = enemy_data.damage
		move_speed = enemy_data.move_speed
	
	add_to_group("enemy")
	hurt_box.add_to_group("enemy")
	health = max_health
	await_player()
	
	random_dir = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
	random_move_switches = 0
	anim.play("move")
	set_random_move_timer()
	set_process(true)


func set_random_move_timer():
	state_timer = 2.0


func _physics_process(_delta: float) -> void:
	if player == null:
		return

	match state:
		State.RANDOM_MOVE:
			state_timer -= _delta
			if state_timer <= 0:
				random_move_switches += 1
				if random_move_switches >= random_move_max_switches:
					state = State.CHARGE_UP
					anim.play("build_up")
					return
				else:
					random_dir = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
					set_random_move_timer()
			# Move in a random direction
			velocity = random_dir * move_speed + knockback_velocity
			knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * _delta)
			move_and_slide()
			
			if is_on_wall() or is_on_ceiling() or is_on_floor():
				random_dir *= -1
		
		State.CHARGE_UP:
			# Wait for the charge_up animation to finish
			if not anim.is_playing():
				state = State.CHARGING
				charge_direction = (player.global_position - global_position).normalized()
				charge_timer = charge_duration
				anim.play("charge")
				return
		
		State.CHARGING:
			charge_timer -= _delta
			velocity = charge_direction * charge_speed
			move_and_slide()
			if charge_timer <= 0:
				velocity = Vector2.ZERO
				state = State.WAIT
				state_timer = wait_time
		
		State.WAIT:
			state_timer -= _delta
			if state_timer <= 0:
				state = State.RANDOM_MOVE
				anim.play("move")
				random_move_switches = 0
				set_random_move_timer()
				random_dir = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
				return


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
