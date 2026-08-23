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

const POISON_TICK_INTERVAL : float = 0.75

enum STATUS {
	SLOW,
	POISON
}

var status_effects : Array[STATUS] = []
var poison_bubble_scene = preload("res://Enemies/Status_Effects/Poison_Bubble/Poison_Bubble.tscn")
var poison_tick_timer: Timer = null


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
