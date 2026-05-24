extends Area2D
class_name Bullet

@export var speed : float = 800
@export var damage : float = 1
var direction := Vector2.ZERO


func _ready() -> void:
	damage = RunManager.player.damage * RunManager.player.damage_mult
	speed = RunManager.player.bullet_speed
	add_to_group("player_bullet")
	area_entered.connect(_on_area_entered)
	print("Scale: ", $Sprite2D.scale)


func _process(delta):
	position += direction * speed * delta


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()


func _on_area_entered(area):
	# If it hits a wall or anything solid → delete
	if area.is_in_group("bullet_bounds"):
		end_bullet()


func end_bullet() -> void:
	queue_free()
