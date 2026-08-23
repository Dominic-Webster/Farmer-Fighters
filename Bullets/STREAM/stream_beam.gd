extends Node2D
class_name StreamBeam

@export var stream_max_length : float = 5000.0
@export var stream_width : float = 20.0
@export var stream_color : Color = Color(0.3, 1.0, 0.35, 0.9)
@export var stream_wave_amplitude : float = 40.0
@export var stream_wave_speed : float = 8.0
@export var stream_wave_segments : int = 24
@export var stream_wave_spatial_frequency : float = TAU * 2.0
@export var stream_extend_time : float = 0.18
@export var stream_spiral_speed : float = 6.0
@export var stream_bounce_angle_degrees : float = deg_to_rad(20.0)
@export var stream_homing_strength : float = 8.0
@export var stream_homing_range : float = 600.0
@export var stream_boomerang_turn_length : float = 500.0
@export var stream_boomerang_return_angle_degrees : float = deg_to_rad(10.0)

@onready var line_template : Line2D = $Line2D

var player : Player = null
var stream_tick_timer : float = 0.0
var stream_wave_time : float = 0.0
var stream_extend_progress : float = 0.0
var stream_homing_target : Node2D = null
var line_pool : Array[Line2D] = []


func _ready() -> void:
	_apply_visual_settings()
	line_template.visible = false
	line_pool = [line_template]
	z_index = 50


func initialize(target_player: Player) -> void:
	player = target_player
	if player != null:
		global_position = player.global_position


func configure(settings: Dictionary) -> void:
	if settings.is_empty():
		_apply_visual_settings()
		return

	stream_max_length = float(settings.get("stream_max_length", stream_max_length))
	stream_width = float(settings.get("stream_width", stream_width))
	stream_color = settings.get("stream_color", stream_color)
	stream_wave_amplitude = float(settings.get("stream_wave_amplitude", stream_wave_amplitude))
	stream_wave_speed = float(settings.get("stream_wave_speed", stream_wave_speed))
	stream_wave_segments = maxi(int(settings.get("stream_wave_segments", stream_wave_segments)), 1)
	stream_wave_spatial_frequency = float(settings.get("stream_wave_spatial_frequency", stream_wave_spatial_frequency))
	stream_extend_time = maxf(float(settings.get("stream_extend_time", stream_extend_time)), 0.01)
	stream_spiral_speed = float(settings.get("stream_spiral_speed", stream_spiral_speed))
	stream_homing_strength = float(settings.get("stream_homing_strength", stream_homing_strength))
	stream_homing_range = float(settings.get("stream_homing_range", stream_homing_range))
	stream_boomerang_turn_length = maxf(float(settings.get("stream_boomerang_turn_length", stream_boomerang_turn_length)), 0.0)
	stream_boomerang_return_angle_degrees = float(settings.get("stream_boomerang_return_angle_degrees", stream_boomerang_return_angle_degrees))
	_apply_visual_settings()


func _apply_visual_settings() -> void:
	if line_template == null:
		return
	
	for beam_line in line_pool:
		if beam_line == null:
			continue
		beam_line.width = stream_width
		beam_line.default_color = stream_color
	
	line_template.width = stream_width
	line_template.default_color = stream_color


func _process(delta: float) -> void:
	if player == null or not is_instance_valid(player) or not player.stream:
		_hide_stream()
		return
	
	configure(player.stream_settings)
	
	var direction := player.get_shoot_direction()
	if player.movement_locked or direction == Vector2.ZERO:
		_hide_stream()
		return
	
	var start := player.shoot_point_2.global_position
	var homed_direction := _get_homed_stream_direction(direction.normalized(), start, delta)
	
	_update_stream_extend_progress(delta)
	stream_wave_time += delta
	var beam_directions := _get_stream_directions(homed_direction.normalized(), _get_stream_shot_count(), player.tri_shot_spread_degrees, player.eggplant, player.spiral, player.backshot)
	var traces : Array[Dictionary] = []
	var effective_length := stream_max_length * _get_stream_extend_scale()
	
	for beam_direction in beam_directions:
		traces.append(_trace_stream_path(start, beam_direction, player.portobello, effective_length))
	
	_ensure_line_pool(traces.size())
	for i in range(line_pool.size()):
		var beam_line := line_pool[i]
		if beam_line == null:
			continue
		
		if i >= traces.size():
			beam_line.visible = false
			beam_line.points = PackedVector2Array()
			continue
		
		var traced_points: Array = traces[i].get("points", [])
		var local_points := PackedVector2Array()
		for point in traced_points:
			local_points.append(to_local(point))
		
		beam_line.visible = true
		beam_line.points = local_points
		
	var hit_counts : Dictionary = {}
	for trace in traces:
		var enemy_hits: Array = trace.get("enemies", [])
		for enemy_candidate in enemy_hits:
			var enemy_hit := enemy_candidate as Enemy
			if enemy_hit == null or not is_instance_valid(enemy_hit):
				continue
			
			var enemy_id := enemy_hit.get_instance_id()
			hit_counts[enemy_id] = int(hit_counts.get(enemy_id, 0)) + 1
	
	if hit_counts.is_empty():
		stream_tick_timer = 0.0
		return
	
	if player.spiral:
		for trace in traces:
			var enemy_hits: Array = trace.get("enemies", [])
			for enemy_candidate in enemy_hits:
				var enemy_hit := enemy_candidate as Enemy
				if enemy_hit == null or not is_instance_valid(enemy_hit):
					continue
				
				enemy_hit.take_damage(player.damage * player.damage_mult, player.global_position)
				_apply_status(enemy_hit)
				_spawn_stream_explosion(enemy_hit.global_position)
		return
	
	var tick_interval := maxf(player.fire_rate, 0.01)
	stream_tick_timer += delta
	if stream_tick_timer < tick_interval:
		return
	
	var tick_count := int(stream_tick_timer / tick_interval)
	stream_tick_timer -= tick_interval * tick_count
	for trace in traces:
		var enemy_hits: Array = trace.get("enemies", [])
		for enemy_candidate in enemy_hits:
			var enemy_hit := enemy_candidate as Enemy
			if enemy_hit == null or not is_instance_valid(enemy_hit):
				continue

			var enemy_ticks := int(hit_counts.get(enemy_hit.get_instance_id(), 0)) * tick_count
			if enemy_ticks > 0:
				enemy_hit.take_damage((player.damage * player.damage_mult) * float(enemy_ticks), player.global_position)
				_apply_status(enemy_hit)
				_spawn_stream_explosion(enemy_hit.global_position)


func _ensure_line_pool(required_count: int) -> void:
	if required_count <= 0:
		return

	while line_pool.size() < required_count:
		var beam_line := line_template.duplicate() as Line2D
		if beam_line == null:
			beam_line = Line2D.new()
			beam_line.width = stream_width
			beam_line.default_color = stream_color
		beam_line.name = "StreamLine_%d" % line_pool.size()
		beam_line.visible = false
		add_child(beam_line)
		line_pool.append(beam_line)


func _trace_stream_path(start: Vector2, direction: Vector2, is_wavy: bool, stream_length: float) -> Dictionary:
	var points: Array[Vector2] = [start]
	var hit_enemies: Array[Enemy] = []
	var accuracy_min: float = player.accuracy.x if player != null else 0.0
	var accuracy_max: float = player.accuracy.y if player != null else 0.0
	var has_accuracy_waver := accuracy_min != 0.0 or accuracy_max != 0.0
	var ignored_colliders: Array = [player, player.push_area, player.hurt_box]
	var remaining_bounces := maxi(player.bounce if player != null else 0, 0)
	var current_start := start
	var current_direction := direction.normalized()
	var remaining_length := stream_length
	var steps := stream_wave_segments if is_wavy else 1
	var boomerang_turned := false

	while remaining_length > 0.0:
		var previous_point := current_start
		var side := current_direction.orthogonal().normalized()
		var bounced := false
		var homing_target := _get_stream_homing_target(current_start)
		var turn_distance := stream_boomerang_turn_length - start.distance_to(current_start)
		var is_turning_now := player != null and player.boomerang and not boomerang_turned and turn_distance <= remaining_length
		if is_turning_now and turn_distance < 0.0:
			turn_distance = 0.0

		for i in range(1, steps + 1):
			var t := float(i) / float(steps)
			if homing_target != null and is_instance_valid(homing_target):
				var target_direction := homing_target.global_position - current_start
				if target_direction != Vector2.ZERO:
					var homing_step : float = clamp(stream_homing_strength * (1.0 / float(steps)), 0.0, 1.0)
					current_direction = current_direction.lerp(target_direction.normalized(), homing_step).normalized()
					side = current_direction.orthogonal().normalized()
			var candidate := current_start + current_direction * remaining_length * t
			var segment_start := previous_point
			var segment_end := candidate
			var segment_continue := true

			if has_accuracy_waver:
				var accuracy_phase: float = (sin(stream_wave_time * 5.0 + t * TAU) + 1.0) * 0.5
				var accuracy_offset: float = lerpf(accuracy_min, accuracy_max, accuracy_phase)
				candidate += side * remaining_length * accuracy_offset * 0.15
				segment_end = candidate

			if is_wavy:
				var wave := sin((stream_wave_time * stream_wave_speed) + (t * stream_wave_spatial_frequency)) * stream_wave_amplitude
				candidate += side * wave
				segment_end = candidate

			if is_turning_now:
				var turn_point := current_start + current_direction * turn_distance
				if segment_end.distance_to(current_start) > turn_distance:
					segment_end = turn_point

			while segment_continue:
				var ray_query := PhysicsRayQueryParameters2D.create(segment_start, segment_end)
				ray_query.collide_with_areas = true
				ray_query.collide_with_bodies = true
				ray_query.exclude = ignored_colliders
				var ray_hit := get_world_2d().direct_space_state.intersect_ray(ray_query)

				if ray_hit.is_empty():
					points.append(segment_end)
					previous_point = segment_end
					if is_turning_now:
						remaining_length = maxf(stream_length - turn_distance, 0.0)
						current_start = segment_end + _get_boomerang_return_direction(current_direction) * 0.5
						current_direction = _get_boomerang_return_direction(current_direction)
						boomerang_turned = true
						bounced = true
					segment_continue = false
					continue

				var hit_position: Vector2 = ray_hit.position
				points.append(hit_position)
				var hit_collider: Object = ray_hit.get("collider", null)
				if _should_ignore_stream_hit(hit_collider):
					ignored_colliders.append(hit_collider)
					segment_start = hit_position + current_direction * 0.5
					if segment_start.distance_to(segment_end) <= 0.5:
						segment_continue = false
					continue

				if _should_bounce_stream_hit(hit_collider) and remaining_bounces > 0:
					remaining_bounces -= 1
					var travelled := current_start.distance_to(hit_position)
					remaining_length -= travelled
					if remaining_length <= 0.0:
						return {
							"points": points,
							"enemies": hit_enemies,
						}

					var bounce_normal: Vector2 = ray_hit.normal
					if bounce_normal == Vector2.ZERO:
						bounce_normal = -current_direction
					current_direction = current_direction.bounce(bounce_normal).normalized()
					current_direction = current_direction.rotated(stream_bounce_angle_degrees).normalized()
					current_start = hit_position + current_direction * 0.5
					bounced = true
					break

				var hit_enemy: Enemy = _resolve_enemy_from_stream_hit(hit_collider)
				if hit_enemy != null:
					hit_enemies.append(hit_enemy)
					if player.piercing:
						_ignore_enemy_colliders(ignored_colliders, hit_enemy)
						segment_start = hit_position + current_direction * 0.5
						if segment_start.distance_to(segment_end) <= 0.5:
							segment_continue = false
						else:
							continue

					return {
						"points": points,
						"enemies": hit_enemies,
					}

				return {
					"points": points,
					"enemies": hit_enemies,
				}

		if bounced:
			continue
		break

	return {
		"points": points,
		"enemies": hit_enemies,
	}


func _get_stream_directions(base_direction: Vector2, shot_count: int, spread_degrees: float, eggplant_level: int, is_spiral: bool, is_backshot: bool) -> Array[Vector2]:
	var directions: Array[Vector2] = []

	if eggplant_level <= 0:
		directions = [base_direction]
	elif eggplant_level == 1:
		directions = [
			Vector2.UP,
			Vector2.RIGHT,
			Vector2.DOWN,
			Vector2.LEFT,
		]
	else:
		directions = [
			Vector2.UP,
			Vector2(1, 1).normalized(),
			Vector2.RIGHT,
			Vector2(1, -1).normalized(),
			Vector2.DOWN,
			Vector2(-1, -1).normalized(),
			Vector2.LEFT,
			Vector2(-1, 1).normalized(),
		]

	var spread_directions: Array[Vector2] = []
	for base in directions:
		spread_directions.append_array(_get_stream_shot_directions(base, shot_count, spread_degrees))
	directions = spread_directions

	if is_backshot and eggplant_level <= 0:
		var backshot_directions := _get_stream_shot_directions(-base_direction, shot_count, spread_degrees)
		directions.append_array(backshot_directions)

	if not is_spiral:
		return directions
	
	var spiral_angle := stream_wave_time * stream_spiral_speed
	for i in range(directions.size()):
		directions[i] = directions[i].rotated(spiral_angle)

	return directions


func _get_stream_shot_count() -> int:
	if player == null:
		return 1

	if player.five_shot:
		return 5
	if player.quad_shot:
		return 4
	if player.tri_shot:
		return 3
	if player.dual_shot:
		return 2
	return 1


func _get_stream_shot_directions(direction: Vector2, count: int, spread_degrees: float) -> Array[Vector2]:
	var dirs: Array[Vector2] = []
	if direction == Vector2.ZERO:
		dirs.append(direction)
		return dirs
	
	if count <= 1:
		dirs.append(direction.normalized())
		return dirs
	
	for i in range(count):
		var idx := float(i) - float(count - 1) / 2.0
		var angle_deg := idx * spread_degrees
		dirs.append(direction.rotated(deg_to_rad(angle_deg)).normalized())
	
	return dirs


func _get_homed_stream_direction(base_direction: Vector2, origin: Vector2, delta: float) -> Vector2:
	if player == null or not player.homing or player.spiral:
		stream_homing_target = null
		return base_direction
	
	_update_stream_homing_target(origin)
	if stream_homing_target == null:
		return base_direction
	
	var target_direction := stream_homing_target.global_position - origin
	if target_direction == Vector2.ZERO:
		return base_direction
	
	return base_direction.lerp(target_direction.normalized(), clamp(stream_homing_strength * delta, 0.0, 1.0)).normalized()


func _get_stream_homing_target(origin: Vector2) -> Node2D:
	if player == null or not player.homing or player.spiral:
		return null
	
	_update_stream_homing_target(origin)
	return stream_homing_target


func _get_boomerang_return_direction(forward_direction: Vector2) -> Vector2:
	if forward_direction == Vector2.ZERO:
		return Vector2.ZERO
	
	return (-forward_direction).rotated(stream_boomerang_return_angle_degrees).normalized()


func _update_stream_homing_target(origin: Vector2) -> void:
	if _is_valid_stream_homing_target(stream_homing_target, origin):
		return
	
	stream_homing_target = _acquire_stream_homing_target(origin)


func _acquire_stream_homing_target(origin: Vector2) -> Node2D:
	var best_target: Node2D = null
	var best_distance: float = stream_homing_range
	
	for node in get_tree().get_nodes_in_group("enemy"):
		if not node is Enemy:
			continue
	
		var enemy: Enemy = node
		if not _can_be_stream_homed(enemy, origin):
			continue
	
		var distance := origin.distance_to(enemy.global_position)
		if distance > best_distance:
			continue
	
		best_distance = distance
		best_target = enemy
	
	return best_target


func _is_valid_stream_homing_target(candidate: Node2D, origin: Vector2) -> bool:
	if candidate == null or not is_instance_valid(candidate):
		return false
	
	if not candidate is Enemy:
		return false
	
	var enemy: Enemy = candidate
	if enemy.is_dead:
		return false
	
	return origin.distance_to(enemy.global_position) <= stream_homing_range


func _can_be_stream_homed(enemy: Enemy, origin: Vector2) -> bool:
	if not is_instance_valid(enemy):
		return false
	
	if enemy.is_dead:
		return false
	
	return origin.distance_to(enemy.global_position) <= stream_homing_range


func _resolve_enemy_from_stream_hit(collider: Object) -> Enemy:
	if collider == null:
		return null
	
	if collider is Enemy:
		return collider
	
	if collider is Area2D and collider.is_in_group("enemy"):
		var parent: Node = collider.get_parent()
		if parent is Enemy:
			return parent
	
	return null


func _should_ignore_stream_hit(collider: Object) -> bool:
	if collider == null:
		return false
	
	if collider is Node and collider.is_in_group("stream_passthrough"):
		return true
	
	if collider is Node and collider.is_in_group("enemy_bullet"):
		return true
	
	if collider is Node and collider.is_in_group("hazard"):
		return true
	
	return false


func _should_bounce_stream_hit(collider: Object) -> bool:
	if collider is Node and collider.is_in_group("bullet_bounds"):
		return true
	
	if collider is StaticBody2D:
		var parent_node: Node = collider.get_parent()
		if parent_node != null and parent_node.name == "Walls":
			return true
	
	return false


func _ignore_enemy_colliders(ignored_colliders: Array, enemy: Enemy) -> void:
	if enemy == null:
		return
	
	if enemy not in ignored_colliders:
		ignored_colliders.append(enemy)
	
	if "hurt_box" in enemy:
		var enemy_hurt_box = enemy.hurt_box
		if enemy_hurt_box != null and enemy_hurt_box not in ignored_colliders:
			ignored_colliders.append(enemy_hurt_box)


func _hide_stream() -> void:
	stream_tick_timer = 0.0
	stream_extend_progress = 0.0
	for beam_line in line_pool:
		if beam_line == null:
			continue
		beam_line.visible = false
		beam_line.points = PackedVector2Array()


func _get_stream_extend_scale() -> float:
	var eased_progress := stream_extend_progress * stream_extend_progress
	return clampf(eased_progress, 0.0, 1.0)


func _update_stream_extend_progress(delta: float) -> void:
	var extend_step := delta / stream_extend_time
	stream_extend_progress = move_toward(stream_extend_progress, 1.0, extend_step)


func _spawn_stream_explosion(_position: Vector2) -> void:
	if not player.explosion:
		return

	var explosion_scene: PackedScene = load("res://Bullets/EXPLOSION/EXPLOSION.tscn")
	if explosion_scene == null:
		return

	var explosion := explosion_scene.instantiate()
	if explosion == null:
		return

	explosion.global_position = _position
	if "use_player_damage" in explosion:
		explosion.use_player_damage = false
	if "damage" in explosion:
		explosion.damage = player.explosion_damage * player.explosion_damage_mult

	if RunManager.current_room_instance != null:
		RunManager.current_room_instance.call_deferred("spawn_explosion_effect", explosion)
	else:
		add_child(explosion)


func _apply_status(enemy: Enemy) -> void:
	if player == null:
		return
	
	if enemy == null or not is_instance_valid(enemy):
		return
	
	if player.slow_bullets and enemy.has_method("apply_status"):
		enemy.apply_status("slow")
	
	if player.poison_bullets and enemy.has_method("apply_status"):
		enemy.apply_status("poison")
