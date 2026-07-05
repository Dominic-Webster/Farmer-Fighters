extends Bullet
class_name CornBullet


func _ready() -> void:
	super._ready()
	if direction != Vector2.ZERO:
		rotation = direction.angle() + PI / 2
