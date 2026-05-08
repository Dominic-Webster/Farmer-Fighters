extends Area2D
class_name Bullet

@export var speed : float = 800
@export var damage : int = 1
var direction := Vector2.ZERO


func _ready() -> void:
	add_to_group("player_bullet")
	body_entered.connect(_on_body_entered)


func _process(delta):
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_body_entered(body):
	# If it hits a wall or anything solid → delete
	if not body.is_in_group("enemy"):
		queue_free()
