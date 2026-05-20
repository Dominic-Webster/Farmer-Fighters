extends Area2D
class_name EnemyBullet

@export var data : EnemyBulletData

var speed : float = 700
var damage : float = 1
var direction := Vector2.ZERO


func _ready() -> void:
	if not data == null:
		damage = data.damage
		speed = data.bullet_speed
	
	add_to_group("enemy_bullet")
	area_entered.connect(_on_area_entered)


func _process(delta):
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area):
	# If it hits a wall or anything solid → delete
	if area.is_in_group("bullet_bounds"):
		queue_free()
