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

enum STATUS {
	SLOW
}

var status_effects : Array[STATUS] = []


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


#func _physics_process(_delta: float) -> void:
	#if player == null:
		#return
	#
	#var direction = (player.global_position - global_position).normalized()
	#var move_velocity = direction * move_speed
	#
	#velocity = move_velocity + knockback_velocity
	#knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * _delta)
	#
	#move_and_slide()


func take_damage(amount: float, from_position : Vector2):
	health -= amount
	
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


func _on_hurt_box_area_entered(area):
	if area.is_in_group("companion") or area.is_in_group("comp_bullet"):
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
	
	is_flashing = true
	sprite.modulate = Color(1, 0.4, 0.4) # red
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1) # back to normal
	is_flashing = false


func apply_status(status : String):
	match status:
		"slow":
			if not status_effects.has(STATUS.SLOW):
				status_effects.append(STATUS.SLOW)
				move_speed /= 2


func remove_status(status : String):
	match status:
		"slow":
			if status_effects.has(STATUS.SLOW):
				status_effects.erase(STATUS.SLOW)
				move_speed *= 2


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
