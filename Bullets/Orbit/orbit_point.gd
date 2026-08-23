extends Node2D

@export var orbit_radius : float = 75.0
@export var orbit_speed : float = 5.0
@export var boomerang_turn_distance : float = 500.0
@export var homing_strength : float = 8.0
@export var homing_range : float = 600.0
@export var spiral_outward_speed : float = 220.0
@export var spiral_spin_speed : float = 10.0
@export var loop_wave_amplitude : float = 0.0
@export var loop_wave_frequency : float = 0.0
@export var bounce_angle_degrees : Vector2 = Vector2(-30.0, 30.0)

var direction : Vector2 = Vector2.ZERO
var bullet_scene : PackedScene
var speed : float = 800.0
var orbit_angle : float = 0.0
var bullets : Array[Bullet] = []
var homing : bool = false
var boomerang : bool = false
var wave : bool = false
var spiral : bool = false
var target : Node2D = null
var _spawn_position : Vector2 = Vector2.ZERO
var _is_returning : bool = false
var _boomerang_returned : bool = false
var _boomerang_released : bool = false
var _spiral_angle : float = 0.0
var _spiral_radius : float = 0.0
var _wave_time : float = 0.0
var _bounce_remaining : int = 0
var _bounce_cooldown : float = 0.0


func setup(projectile_scene: PackedScene, shot_direction: Vector2) -> void:
	bullet_scene = projectile_scene
	direction = shot_direction.normalized()
	if RunManager.player != null:
		var player := RunManager.player
		speed = player.bullet_speed
		homing = player.homing
		boomerang = player.boomerang
		wave = player.portobello
		spiral = player.spiral
		_bounce_remaining = player.bounce if not spiral else 0

	homing_strength = 8.0
	homing_range = 600.0
	boomerang_turn_distance = 500.0
	spiral_outward_speed = speed * 0.25
	spiral_spin_speed = speed / 85.0
	loop_wave_amplitude = speed
	loop_wave_frequency = speed / 90.0


func _ready() -> void:
	if bullet_scene == null:
		queue_free()
		return

	for index in range(3):
		var bullet := bullet_scene.instantiate() as Bullet
		if bullet == null:
			continue

		bullet.orbit_managed = true
		bullet.direction = direction
		add_child(bullet)
		bullets.append(bullet)

	_spawn_position = global_position
	_spiral_angle = direction.angle()
	_wave_time = 0.0
	_update_bullet_positions()


func _process(delta: float) -> void:
	bullets = bullets.filter(func(bullet): return is_instance_valid(bullet))
	_bounce_cooldown = maxf(_bounce_cooldown - delta, 0.0)
	_update_target()
	_apply_homing(delta)
	_update_boomerang()

	orbit_angle = wrapf(orbit_angle + orbit_speed * delta, 0.0, TAU)
	if spiral:
		_update_spiral(delta)
	else:
		_move_forward(delta)
		_apply_wave(delta)

	_update_bullet_positions()

	if bullets.is_empty():
		queue_free()


func orbit_hit_wall(wall_name: String, bullet: Bullet) -> void:
	if _bounce_cooldown > 0.0:
		return

	if _bounce_remaining <= 0:
		if is_instance_valid(bullet):
			bullet.end_bullet()
		return

	_bounce_remaining -= 1
	_bounce_cooldown = 0.08
	_bounce_from_wall(wall_name)
	for orbit_bullet in bullets:
		if is_instance_valid(orbit_bullet):
			orbit_bullet.reset_hits_for_orbit_return()


func _bounce_from_wall(wall_name: String) -> void:
	var angle_offset := deg_to_rad(randf_range(bounce_angle_degrees.x, bounce_angle_degrees.y))
	var new_direction := direction.normalized()

	match wall_name:
		"Top", "Bottom":
			new_direction.y = -new_direction.y
			new_direction = new_direction.rotated(angle_offset)
		"Left", "Right":
			new_direction.x = -new_direction.x
			new_direction = new_direction.rotated(-angle_offset)
		"Crate", "Crate2", "Crate3":
			new_direction *= -1.0
			new_direction = new_direction.rotated(-angle_offset)
		_:
			new_direction *= -1.0
			new_direction = new_direction.rotated(-angle_offset)

	direction = new_direction.normalized()
	global_position += direction * 4.0


func _update_target() -> void:
	if not homing or _is_returning:
		target = null
		return

	if _is_valid_target(target):
		if global_position.distance_to(target.global_position) <= homing_range:
			return

	target = _acquire_target()


func _apply_homing(delta: float) -> void:
	if not homing or _is_returning or target == null:
		return

	_steer_toward(target.global_position - global_position, delta)


func _update_boomerang() -> void:
	if not boomerang or _boomerang_released:
		return

	if not _is_returning and global_position.distance_to(_spawn_position) >= boomerang_turn_distance:
		_is_returning = true
		_boomerang_returned = true
		target = null
		for bullet in bullets:
			if is_instance_valid(bullet):
				bullet.reset_hits_for_orbit_return()
		if RunManager.player != null:
			direction = (RunManager.player.global_position - global_position).normalized()
		return

	if not _is_returning or RunManager.player == null:
		return

	if _boomerang_returned and global_position.distance_to(RunManager.player.global_position) <= boomerang_turn_distance * 0.5:
		_is_returning = false
		_boomerang_released = true
		_boomerang_returned = false


func _move_forward(delta: float) -> void:
	if direction != Vector2.ZERO:
		position += direction.normalized() * speed * delta


func _apply_wave(delta: float) -> void:
	if not wave:
		return

	_wave_time += delta
	var forward := direction.normalized()
	if forward == Vector2.ZERO:
		return

	var sideways := forward.orthogonal().normalized()
	var wave_offset := sin(_wave_time * loop_wave_frequency) * loop_wave_amplitude
	position += sideways * wave_offset * delta


func _update_spiral(delta: float) -> void:
	_spiral_radius += spiral_outward_speed * delta
	_spiral_angle += spiral_spin_speed * delta
	global_position = _spawn_position + Vector2.from_angle(_spiral_angle) * _spiral_radius


func _steer_toward(target_direction: Vector2, delta: float) -> void:
	if target_direction == Vector2.ZERO:
		return

	var desired_direction := target_direction.normalized()
	if direction == Vector2.ZERO:
		direction = desired_direction
		return

	direction = direction.lerp(desired_direction, clamp(homing_strength * delta, 0.0, 1.0)).normalized()


func _acquire_target() -> Node2D:
	var best_target : Node2D = null
	var best_distance := homing_range

	for node in get_tree().get_nodes_in_group("enemy"):
		if not node is Enemy:
			continue

		var enemy : Enemy = node
		if enemy.is_dead:
			continue

		var distance := global_position.distance_to(enemy.global_position)
		if distance <= best_distance:
			best_distance = distance
			best_target = enemy

	return best_target


func _is_valid_target(candidate: Node2D) -> bool:
	return candidate != null and is_instance_valid(candidate) and candidate is Enemy and not candidate.is_dead


func _update_bullet_positions() -> void:
	for index in range(bullets.size()):
		var bullet := bullets[index]
		if not is_instance_valid(bullet):
			continue

		var angle := orbit_angle + (TAU * float(index) / 3.0)
		bullet.position = Vector2.RIGHT.rotated(angle) * orbit_radius
