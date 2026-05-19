extends Enemy
class_name EnergyDrink


enum State { RANDOM_MOVE, CHARGE_UP, CHARGING, WAIT }
var state = State.RANDOM_MOVE
var state_timer = 0.0
var random_move_time = 1.5
var wait_time = 1.0
var charge_speed = 1000
var charge_direction = Vector2.ZERO
var rng = RandomNumberGenerator.new()

var random_dir = Vector2.ZERO
var random_move_switches = 0
var random_move_max_switches = 3

var charge_timer = 0.0
var charge_duration = 1.5

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
	anim.play("moving")
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
					anim.play("charge_up")
					return
				else:
					random_dir = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
					set_random_move_timer()
			# Move in a random direction
			velocity = random_dir * move_speed + knockback_velocity
			knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * _delta)
			move_and_slide()
		
		State.CHARGE_UP:
			# Wait for the charge_up animation to finish
			if not anim.is_playing():
				state = State.CHARGING
				charge_direction = (player.global_position - global_position).normalized()
				charge_timer = charge_duration
				anim.play("moving")
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
				anim.play("moving")
				random_move_switches = 0
				set_random_move_timer()
				random_dir = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
				return


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

		# Spawn elevator after boss defeat at center of screen
		var elevator = ElevatorScene.instantiate()
		get_parent().add_child(elevator)
		# Center in viewport
		var viewport = get_viewport()
		var center = viewport.get_visible_rect().size / 2
		elevator.global_position = center
		elevator.load_in()
		await get_tree().process_frame # Ensure elevator is in scene tree
		await elevator.lower()

		# Store elevator state and position for persistence
		var pos = RunManager.current_room
		var state = MapGenerationManager.room_states.get(pos, {})
		state["elevator_present"] = true
		state["elevator_position"] = elevator.global_position
		MapGenerationManager.room_states[pos] = state

		queue_free()
