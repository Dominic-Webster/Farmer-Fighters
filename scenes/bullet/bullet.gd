extends Area2D
class_name Bullet

@export var speed : float = 800
@export var damage : int = 1
var direction := Vector2.ZERO


func _ready() -> void:
	add_to_group("player_bullet")


func _process(delta):
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
