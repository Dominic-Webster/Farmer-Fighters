extends Area2D
class_name Bullet

@export var speed : float = 800
@export var damage : float = 1
@export var boomerang_turn_distance : float = 500.0
var direction := Vector2.ZERO
var _ended : bool = false
var _spawn_position : Vector2 = Vector2.ZERO
var _is_returning : bool = false

const ExplosionScene = preload("res://Bullets/EXPLOSION/EXPLOSION.tscn")


func _ready() -> void:
	damage = RunManager.player.damage * RunManager.player.damage_mult
	speed = RunManager.player.bullet_speed
	_spawn_position = global_position
	add_to_group("player_bullet")
	area_entered.connect(_on_area_entered)


func _process(delta):
	if RunManager.player != null and RunManager.player.boomerang:
		if not _is_returning and global_position.distance_to(_spawn_position) >= boomerang_turn_distance:
			_is_returning = true
			direction = -direction

	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area):
	# If it hits a wall or anything solid → delete
	if area.is_in_group("bullet_bounds"):
		end_bullet()


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
