extends CharacterBody2D
class_name Enemy

signal died

var player : Player
@onready var sprite: Sprite2D = $Sprite2D
@onready var hurt_box : Area2D = $HurtBox
@onready var anim : AnimationPlayer = $AnimationPlayer

@export var enemy_data : EnemyData

var weight : int = 1

var move_speed : float = 150
var damage : int = 1
var max_health : float = 3
var health : float = 0

var is_flashing : bool = false
var is_dead : bool = false

var knockback_velocity := Vector2.ZERO

const CHASE_CELL_SIZE := 48.0
const CHASE_GRID_SIZE := Vector2i(40, 23)
const CHASE_OBSTACLE_MASK := 16 | 512

var chase_path := PackedVector2Array()
var chase_path_index := 0
var chase_repath_timer := 0.0

const POISON_TICK_INTERVAL : float = 0.75

enum STATUS {
	SLOW,
	POISON
}

var status_effects : Array[STATUS] = []
var poison_bubble_scene = preload("res://Enemies/Status_Effects/Poison_Bubble/Poison_Bubble.tscn")
var poison_tick_timer: Timer = null


func get_chase_direction(target_position: Vector2, delta: float) -> Vector2:
	var direct_direction := global_position.direction_to(target_position)
	if _has_clear_chase_line(target_position):
		chase_path = PackedVector2Array()
		return direct_direction

	chase_repath_timer -= delta
	if delta <= 0.0 or chase_repath_timer <= 0.0 or chase_path_index >= chase_path.size():
		_rebuild_chase_path(target_position)

	while chase_path_index < chase_path.size() and global_position.distance_to(chase_path[chase_path_index]) < CHASE_CELL_SIZE * 0.35:
		chase_path_index += 1

	if chase_path_index < chase_path.size():
		return global_position.direction_to(chase_path[chase_path_index])

	return direct_direction


func _has_clear_chase_line(target_position: Vector2) -> bool:
	var query := PhysicsRayQueryParameters2D.create(global_position, target_position, CHASE_OBSTACLE_MASK)
	query.exclude = [get_rid()]
	query.collide_with_areas = true
	return get_world_2d().direct_space_state.intersect_ray(query).is_empty()


func _rebuild_chase_path(target_position: Vector2) -> void:
	chase_repath_timer = 0.25
	chase_path = PackedVector2Array()
	chase_path_index = 0

	var grid := AStarGrid2D.new()
	grid.region = Rect2i(Vector2i.ZERO, CHASE_GRID_SIZE)
	grid.cell_size = Vector2.ONE * CHASE_CELL_SIZE
	grid.offset = Vector2.ONE * CHASE_CELL_SIZE * 0.5
	grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	grid.update()

	var query_shape := CircleShape2D.new()
	query_shape.radius = min(get_collision_radius(), CHASE_CELL_SIZE * 0.45)
	var space_state := get_world_2d().direct_space_state
	for y in CHASE_GRID_SIZE.y:
		for x in CHASE_GRID_SIZE.x:
			var cell := Vector2i(x, y)
			var query := PhysicsShapeQueryParameters2D.new()
			query.shape = query_shape
			query.transform = Transform2D(0.0, grid.get_point_position(cell))
			query.collision_mask = CHASE_OBSTACLE_MASK
			query.exclude = [get_rid()]
			query.collide_with_areas = true
			if not space_state.intersect_shape(query, 1).is_empty():
				grid.set_point_solid(cell, true)

	var start_cell := _chase_cell_for_position(global_position)
	var target_cell := _chase_cell_for_position(target_position)
	grid.set_point_solid(start_cell, false)
	grid.set_point_solid(target_cell, false)
	chase_path = grid.get_point_path(start_cell, target_cell)
	if chase_path.size() > 0:
		chase_path_index = 1


func _chase_cell_for_position(world_position: Vector2) -> Vector2i:
	var cell := Vector2i(floor(world_position / CHASE_CELL_SIZE))
	return Vector2i(
		clampi(cell.x, 0, CHASE_GRID_SIZE.x - 1),
		clampi(cell.y, 0, CHASE_GRID_SIZE.y - 1)
	)


func get_collision_radius() -> float:
	var collision_shape := get_node_or_null("CollisionShape2D") as CollisionShape2D
	if collision_shape == null or collision_shape.shape == null:
		return 24.0
	if collision_shape.shape is CircleShape2D:
		return collision_shape.shape.radius * max(collision_shape.scale.x, collision_shape.scale.y)
	if collision_shape.shape is RectangleShape2D:
		return min(collision_shape.shape.size.x, collision_shape.shape.size.y) * 0.5
	return 24.0


func _ready():
	if not enemy_data == null:
		max_health = enemy_data.health
		damage = enemy_data.damage
		move_speed = enemy_data.move_speed
	
	add_to_group("enemy")
	hurt_box.add_to_group("enemy")
	health = max_health
	await_player()


func await_player() -> void:
	while RunManager.player == null:
		await get_tree().process_frame
	player = RunManager.player


func take_damage(amount: float, from_position : Vector2, apply_knockback : bool = true):
	health -= amount
	
	if apply_knockback:
		var dir = (global_position - from_position).normalized()
		knockback_velocity = dir * 200
	
	flash_red()
	
	if health <= 0:
		die()


func die():
	if not is_dead:
		is_dead = true
		died.emit()
		queue_free()


func _spawn_poison_bubbles() -> void:
	var num : int = randi_range(1, 5)
	for i in range(num):
		var bubble = poison_bubble_scene.instantiate()
		if bubble == null:
			continue

		bubble.global_position = global_position + Vector2(randf_range(-20.0, 20.0), randf_range(-15.0, 10.0))

		if RunManager != null and RunManager.current_room_instance != null:
			RunManager.current_room_instance.call_deferred("add_child", bubble)
		else:
			get_tree().current_scene.call_deferred("add_child", bubble)
		


func _ensure_poison_tick_timer() -> void:
	if poison_tick_timer != null:
		return

	poison_tick_timer = Timer.new()
	poison_tick_timer.name = "PoisonTickTimer"
	poison_tick_timer.wait_time = POISON_TICK_INTERVAL
	poison_tick_timer.one_shot = false
	poison_tick_timer.autostart = false
	poison_tick_timer.timeout.connect(_on_poison_tick_timeout)
	add_child(poison_tick_timer)


func _on_poison_tick_timeout() -> void:
	if is_dead:
		if poison_tick_timer != null:
			poison_tick_timer.stop()
		return

	if not status_effects.has(STATUS.POISON):
		if poison_tick_timer != null:
			poison_tick_timer.stop()
		return

	var current_player: Player = player
	if current_player == null:
		current_player = RunManager.player
		if current_player != null:
			player = current_player

	if current_player == null:
		return

	take_damage(current_player.poison_damage, current_player.global_position, false)
	_spawn_poison_bubbles()


func _on_hurt_box_area_entered(area):
	if area.is_in_group("companion") or area.is_in_group("comp_bullet") or area.is_in_group("rotators"):
		var damage_amount: float = 0.0
		var damage_source = area

		if "damage" in damage_source:
			damage_amount = damage_source.damage
		elif damage_source.get_parent() != null and "damage" in damage_source.get_parent():
			damage_amount = damage_source.get_parent().damage

		if damage_amount > 0:
			take_damage(damage_amount, area.global_position)


func flash_red():
	if is_flashing:
		return
	
	var flash_color : Color = Color(1, 0.4, 0.4)
	if status_effects.has(STATUS.POISON):
		flash_color = Color(0.0, 0.573, 0.0, 1.0)
	
	is_flashing = true
	sprite.modulate = flash_color
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1) # back to normal
	is_flashing = false


func apply_status(status : String):
	match status:
		"slow":
			if not status_effects.has(STATUS.SLOW):
				status_effects.append(STATUS.SLOW)
				move_speed /= 2
		"poison":
			if not status_effects.has(STATUS.POISON):
				status_effects.append(STATUS.POISON)
				_ensure_poison_tick_timer()
				poison_tick_timer.start()


func remove_status(status : String):
	match status:
		"slow":
			if status_effects.has(STATUS.SLOW):
				status_effects.erase(STATUS.SLOW)
				move_speed *= 2
		"poison":
			if status_effects.has(STATUS.POISON):
				status_effects.erase(STATUS.POISON)
				if poison_tick_timer != null:
					poison_tick_timer.stop()


func cherry_shot() -> void:
	if RunManager == null or RunManager.current_room_instance == null:
		return
	
	if RunManager.player == null or RunManager.player.cherry == false:
		return
	
	var cherry_bullet_scene: PackedScene = load("res://Bullets/Cherry_Bullet/cherry_bullet.tscn")
	if cherry_bullet_scene == null:
		push_warning("Failed to load cherry bullet scene")
		return

	var shot_count := _get_player_shot_count(RunManager.player)
	var directions := [Vector2.UP, Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT]
	
	for direction in directions:
		var spread_directions := _get_spread_directions(direction, shot_count, RunManager.player.tri_shot_spread_degrees)
		for spread_direction in spread_directions:
			var player_bullet = cherry_bullet_scene.instantiate()
			player_bullet.global_position = global_position
			player_bullet.direction = spread_direction
			RunManager.current_room_instance.add_child(player_bullet)


func _get_player_shot_count(current_player: Player) -> int:
	if current_player.five_shot:
		return 5
	if current_player.quad_shot:
		return 4
	if current_player.tri_shot:
		return 3
	if current_player.dual_shot:
		return 2
	return 1


func _get_spread_directions(direction: Vector2, count: int, spread_degrees: float) -> Array[Vector2]:
	var dirs: Array[Vector2] = []
	if direction == Vector2.ZERO:
		dirs.append(direction)
		return dirs

	for i in range(count):
		var idx := float(i) - float(count - 1) / 2.0
		var angle_deg := idx * spread_degrees
		dirs.append(direction.rotated(deg_to_rad(angle_deg)).normalized())

	return dirs
