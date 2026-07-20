extends Area2D
class_name Bullet

@export var speed : float = 800
@export var damage : float = 1
@export var boomerang_turn_distance : float = 500.0
@export var homing_strength : float = 8.0
@export var homing_range : float = 600.0
@export var spiral_outward_speed : float = 220.0
@export var spiral_spin_speed : float = 10.0
@export var loop_wave_amplitude : float = 0.0
@export var loop_wave_frequency : float = 0.0
@export var bounce_angle_degrees : Vector2 = Vector2(-30.0, 30.0)
var direction := Vector2.ZERO
var homing : bool = false
var bounce : int = 0
var piercing : bool = false
var boomerang : bool = false
var wave : bool = false
var spiral : bool = false
var explosion : bool = false
var slow_bullets : bool = false
var explosion_damage : float = 2.0
var explosion_damage_mult : float = 1.0
var target : Node2D = null
var _ended : bool = false
var _spawn_position : Vector2 = Vector2.ZERO
var _is_returning : bool = false
var _boomerang_returned : bool = false
var _boomerang_released : bool = false
var _spiral_angle : float = 0.0
var _spiral_radius : float = 0.0
var _wave_time : float = 0.0
var _bounce_remaining : int = 0
var _bounce_angle : float = randf_range(bounce_angle_degrees.x, bounce_angle_degrees.y)
var _hit_enemies : Dictionary = {}

const ExplosionScene = preload("res://Bullets/EXPLOSION/EXPLOSION.tscn")


func _ready() -> void:
	var player = RunManager.player
	if player != null:
		damage = player.damage * player.damage_mult
		speed = player.bullet_speed
		homing = player.homing
		bounce = player.bounce
		piercing = player.piercing
		boomerang = player.boomerang
		wave = player.portobello
		spiral = player.spiral
		explosion = player.explosion
		slow_bullets = player.slow_bullets
		explosion_damage = player.explosion_damage
		explosion_damage_mult = player.explosion_damage_mult

	spiral_outward_speed = speed * 0.25
	spiral_spin_speed = speed / 85.0
	loop_wave_amplitude = speed
	loop_wave_frequency = speed / 90.0
	_bounce_remaining = bounce if spiral == false else 0
	_spawn_position = global_position
	_spiral_angle = direction.angle()
	_wave_time = 0.0
	add_to_group("player_bullet")
	area_entered.connect(_on_area_entered)


func _process(delta):
	_update_target()
	_apply_homing(delta)
	_update_boomerang(delta)

	if spiral:
		_update_spiral(delta)
		return

	_move_forward(delta)
	_apply_wave(delta)


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


func _update_boomerang(_delta: float) -> void:
	if not boomerang or _boomerang_released:
		return

	if not _is_returning and global_position.distance_to(_spawn_position) >= boomerang_turn_distance:
		_is_returning = true
		_boomerang_returned = true
		_reset_hit_enemies()
		target = null
		if RunManager.player != null:
			direction = (RunManager.player.global_position - global_position).normalized()
		return

	if not _is_returning:
		return

	if _boomerang_returned and global_position.distance_to(RunManager.player.global_position) <= boomerang_turn_distance * 0.5:
		_is_returning = false
		_boomerang_released = true
		_boomerang_returned = false


func _move_forward(delta: float) -> void:
	if direction == Vector2.ZERO:
		return

	position += direction.normalized() * speed * delta


func _apply_wave(delta: float) -> void:
	if not wave:
		return

	_wave_time += delta
	var forward = direction.normalized()
	if forward == Vector2.ZERO:
		return

	var sideways = forward.orthogonal().normalized()
	var wave_offset = sin(_wave_time * loop_wave_frequency) * loop_wave_amplitude
	position += sideways * wave_offset * delta


func _update_spiral(delta: float) -> void:
	_spiral_radius += spiral_outward_speed * delta
	_spiral_angle += spiral_spin_speed * delta
	global_position = _spawn_position + Vector2.from_angle(_spiral_angle) * _spiral_radius


func _steer_toward(target_direction: Vector2, delta: float) -> void:
	if target_direction == Vector2.ZERO:
		return

	var desired_direction = target_direction.normalized()
	if direction == Vector2.ZERO:
		direction = desired_direction
		return

	direction = direction.lerp(desired_direction, clamp(homing_strength * delta, 0.0, 1.0)).normalized()


func _acquire_target() -> Node2D:
	var best_target : Node2D = null
	var best_distance : float = homing_range

	for node in get_tree().get_nodes_in_group("enemy"):
		if not node is Enemy:
			continue

		var enemy : Enemy = node
		if not _can_be_targeted(enemy):
			continue

		var distance = global_position.distance_to(enemy.global_position)
		if distance > best_distance:
			continue

		best_distance = distance
		best_target = enemy

	return best_target


func _can_be_targeted(enemy: Enemy) -> bool:
	if not is_instance_valid(enemy):
		return false

	if enemy.is_dead:
		return false

	return not _hit_enemies.has(enemy.get_instance_id())


func _is_valid_target(candidate: Node2D) -> bool:
	if candidate == null or not is_instance_valid(candidate):
		return false

	if not candidate is Enemy:
		return false

	var enemy : Enemy = candidate
	if enemy.is_dead:
		return false

	if _hit_enemies.has(enemy.get_instance_id()):
		return false

	return true


func _reset_hit_enemies() -> void:
	_hit_enemies.clear()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area):
	if _is_player_contact(area):
		return

	if area.is_in_group("bullet_bounds"):
		if _bounce_remaining > 0:
			_bounce_remaining -= 1
			_bounce_from_wall(area.name)
			if homing:
				target = null
		else:
			end_bullet()
		return

	if area.is_in_group("enemy"):
		_handle_enemy_hit(area)


func _is_player_contact(area: Area2D) -> bool:
	var player = RunManager.player
	if player == null:
		return false

	if area == player:
		return true

	if area.is_in_group("player"):
		return true

	return area.get_parent() == player


func _handle_enemy_hit(area: Area2D) -> void:
	var enemy := area.get_parent()
	if enemy == null or not enemy is Enemy:
		return

	if _hit_enemies.has(enemy.get_instance_id()):
		return

	_hit_enemies[enemy.get_instance_id()] = true
	enemy.take_damage(damage, global_position)

	if slow_bullets and enemy.has_method("apply_status"):
		enemy.apply_status("slow")

	if homing:
		if target == enemy:
			target = null
		if not _is_returning:
			_update_target()

	if piercing or bounce > 0 or boomerang or spiral:
		return

	end_bullet()


func _bounce_from_wall(wall_name: String) -> void:
	var angle_offset := deg_to_rad(_bounce_angle)
	var new_direction := direction.normalized()

	match wall_name:
		"Top", "Bottom":
			new_direction.y = -new_direction.y
			new_direction = new_direction.rotated(angle_offset)
		"Left", "Right":
			new_direction.x = -new_direction.x
			new_direction = new_direction.rotated(-angle_offset)
		#"Crate", "Crate2", "Crate3":
			#new_direction *= -1
			#new_direction = new_direction.rotated(-angle_offset)
		_:
			new_direction *= -1
			new_direction = new_direction.rotated(-angle_offset)
			#end_bullet()
			#return

	direction = new_direction.normalized()
	global_position += direction * 4.0
	_reset_hit_enemies()


func end_bullet() -> void:
	if _ended:
		return
	_ended = true

	if explosion:
		_spawn_explosion()
	else:
		queue_free()


func _spawn_explosion() -> void:
	if not is_inside_tree():
		return

	var explsn = ExplosionScene.instantiate()
	explsn.global_position = global_position
	explsn.use_player_damage = false
	explsn.damage = explosion_damage * explosion_damage_mult
	if RunManager.current_room_instance != null:
		RunManager.current_room_instance.call_deferred("spawn_explosion_effect", explsn)

	call_deferred("queue_free")
