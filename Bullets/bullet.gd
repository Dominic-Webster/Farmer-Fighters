extends Area2D
class_name Bullet

@export var speed : float = 800
@export var damage : float = 1
@export var boomerang_turn_distance : float = 500.0
@export var spiral_outward_speed : float = 220.0
@export var spiral_spin_speed : float = 10.0
@export var loop_wave_amplitude : float = 0.0
@export var loop_wave_frequency : float = 0.0
@export var bounce_angle_degrees : Vector2 = Vector2(-30.0, 30.0)
var direction := Vector2.ZERO
var _ended : bool = false
var _spawn_position : Vector2 = Vector2.ZERO
var _is_returning : bool = false
var _spiral_angle : float = 0.0
var _spiral_radius : float = 0.0
var _loop_time : float = 0.0
var _bounce_remaining : int = 0
var _bounce_angle : float = randf_range(bounce_angle_degrees.x, bounce_angle_degrees.y)

const ExplosionScene = preload("res://Bullets/EXPLOSION/EXPLOSION.tscn")


func _ready() -> void:
	damage = RunManager.player.damage * RunManager.player.damage_mult
	speed = RunManager.player.bullet_speed
	spiral_outward_speed = speed * 0.25
	spiral_spin_speed = speed / 85.0
	loop_wave_amplitude = speed
	loop_wave_frequency = speed / 90.0
	_bounce_remaining = RunManager.player.bounce if RunManager.player != null and RunManager.player.spiral == false else 0
	_spawn_position = global_position
	_spiral_angle = direction.angle()
	add_to_group("player_bullet")
	area_entered.connect(_on_area_entered)


func _process(delta):
	if RunManager.player != null and RunManager.player.spiral:
		_update_spiral(delta)
	elif RunManager.player != null and RunManager.player.boomerang:
		if not _is_returning and global_position.distance_to(_spawn_position) >= boomerang_turn_distance:
			_is_returning = true
			direction = -direction

		position += direction * speed * delta
	elif RunManager.player != null and RunManager.player.portobello:
		_update_loop(delta)
	else:
		position += direction * speed * delta


func _update_spiral(delta: float) -> void:
	_spiral_radius += spiral_outward_speed * delta
	_spiral_angle += spiral_spin_speed * delta
	global_position = _spawn_position + Vector2.from_angle(_spiral_angle) * _spiral_radius


func _update_loop(delta: float) -> void:
	_loop_time += delta
	var forward = direction.normalized()
	var sideways = forward.orthogonal().normalized()
	var wave = sin(_loop_time * loop_wave_frequency) * loop_wave_amplitude
	position += forward * speed * delta
	position += sideways * wave * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area):
	# If it hits a wall or anything solid → delete
	if area.is_in_group("bullet_bounds"):
		if _bounce_remaining > 0 and RunManager.player != null:
			_bounce_remaining -= 1
			_bounce_from_wall(area.name)
		else:
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


func end_bullet() -> void:
	if _ended:
		return
	_ended = true

	if RunManager.player != null and RunManager.player.explosion:
		_spawn_explosion()
	else:
		queue_free()


func _spawn_explosion() -> void:
	if not is_inside_tree():
		return

	var explosion = ExplosionScene.instantiate()
	explosion.global_position = global_position
	explosion.damage = RunManager.player.explosion_damage
	if RunManager.current_room_instance != null:
		RunManager.current_room_instance.call_deferred("spawn_explosion_effect", explosion)

	call_deferred("queue_free")
