extends Node2D
class_name StreamBeam

@export var stream_max_length : float = 1600.0
@export var stream_width : float = 20.0
@export var stream_color : Color = Color(0.3, 1.0, 0.35, 0.9)
@export var stream_wave_amplitude : float = 40.0
@export var stream_wave_speed : float = 8.0
@export var stream_wave_segments : int = 24
@export var stream_wave_spatial_frequency : float = TAU * 2.0
@export var stream_extend_time : float = 0.18
@export var stream_spiral_speed : float = 6.0

@onready var line_template : Line2D = $Line2D

var player : Player = null
var stream_tick_timer : float = 0.0
var stream_wave_time : float = 0.0
var stream_extend_progress : float = 0.0
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

	stream_extend_progress = move_toward(stream_extend_progress, 1.0, delta / stream_extend_time)
	stream_wave_time += delta
	var start := player.shoot_point_2.global_position
	var beam_directions := _get_stream_directions(direction.normalized(), _get_stream_shot_count(), player.tri_shot_spread_degrees, player.eggplant, player.spiral, player.backshot)
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
	var previous_point := start
	var hit_enemies: Array[Enemy] = []
	var steps := stream_wave_segments if is_wavy else 1
	var side := direction.orthogonal().normalized()
	var accuracy_min: float = player.accuracy.x if player != null else 0.0
	var accuracy_max: float = player.accuracy.y if player != null else 0.0
	var has_accuracy_waver := accuracy_min != 0.0 or accuracy_max != 0.0
	var ignored_colliders: Array = [player, player.push_area, player.hurt_box]

	for i in range(1, steps + 1):
		var t := float(i) / float(steps)
		var candidate := start + direction * stream_length * t
		var segment_start := previous_point
		var segment_end := candidate
		var segment_continue := true

		if has_accuracy_waver:
			var accuracy_phase: float = (sin(stream_wave_time * 5.0 + t * TAU) + 1.0) * 0.5
			var accuracy_offset: float = lerpf(accuracy_min, accuracy_max, accuracy_phase)
			candidate += side * stream_length * accuracy_offset * 0.15
			segment_end = candidate

		if is_wavy:
			var wave := sin((stream_wave_time * stream_wave_speed) + (t * stream_wave_spatial_frequency)) * stream_wave_amplitude
			candidate += side * wave
			segment_end = candidate

		while segment_continue:
			var ray_query := PhysicsRayQueryParameters2D.create(segment_start, segment_end)
			ray_query.collide_with_areas = true
			ray_query.collide_with_bodies = true
			ray_query.exclude = ignored_colliders
			var ray_hit := get_world_2d().direct_space_state.intersect_ray(ray_query)

			if ray_hit.is_empty():
				points.append(segment_end)
				previous_point = segment_end
				segment_continue = false
				continue

			var hit_position: Vector2 = ray_hit.position
			points.append(hit_position)
			var hit_collider: Object = ray_hit.get("collider", null)
			if _should_ignore_stream_hit(hit_collider):
				ignored_colliders.append(hit_collider)
				segment_start = hit_position + direction * 0.5
				if segment_start.distance_to(segment_end) <= 0.5:
					segment_continue = false
				continue

			var hit_enemy: Enemy = _resolve_enemy_from_stream_hit(hit_collider)
			if hit_enemy != null:
				hit_enemies.append(hit_enemy)
				if player.piercing:
					_ignore_enemy_colliders(ignored_colliders, hit_enemy)
					segment_start = hit_position + direction * 0.5
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
