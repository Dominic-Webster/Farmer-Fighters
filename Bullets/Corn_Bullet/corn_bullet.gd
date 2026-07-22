extends Bullet
class_name CornBullet


func _ready() -> void:
	super._ready()
	_sync_rotation()


func _process(delta):
	super._process(delta)
	_sync_rotation()


func _sync_rotation() -> void:
	if direction != Vector2.ZERO:
		rotation = direction.angle() + PI / 2
