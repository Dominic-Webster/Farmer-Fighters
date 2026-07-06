extends Area2D
class_name Bullet

@export var speed : float = 800
@export var damage : float = 1
var direction := Vector2.ZERO
var _ended : bool = false

const ExplosionScene = preload("res://Bullets/EXPLOSION/EXPLOSION.tscn")


func _ready() -> void:
	damage = RunManager.player.damage * RunManager.player.damage_mult
	speed = RunManager.player.bullet_speed
	add_to_group("player_bullet")
	area_entered.connect(_on_area_entered)


func _process(delta):
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

	if RunManager.player != null and RunManager.player.potato:
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
