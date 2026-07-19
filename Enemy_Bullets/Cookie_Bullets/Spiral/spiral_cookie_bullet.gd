extends EnemyBullet

@export var spiral_outward_speed : float = 220.0
@export var spiral_spin_speed : float = 10.0

var _spawn_position : Vector2 = Vector2.ZERO
var _spiral_angle : float = 0.0
var _spiral_radius : float = 0.0


func _process(delta):
	#super._process(delta)
	_update_spiral(delta)


func _update_spiral(delta: float) -> void:
	_spiral_radius += spiral_outward_speed * delta
	_spiral_angle += spiral_spin_speed * delta
	global_position = _spawn_position + Vector2.from_angle(_spiral_angle) * _spiral_radius
