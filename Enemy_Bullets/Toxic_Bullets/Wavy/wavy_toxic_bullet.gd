extends EnemyBullet

@export var loop_wave_amplitude : float = 0.0
@export var loop_wave_frequency : float = 0.0

var _loop_time : float = 0.0


func _ready() -> void:
	super._ready()
	loop_wave_amplitude = speed
	loop_wave_frequency = speed / 90.0


func _process(delta):
	super._process(delta)
	_update_loop(delta)


func _update_loop(delta: float) -> void:
	_loop_time += delta
	var forward = direction.normalized()
	var sideways = forward.orthogonal().normalized()
	var wave = sin(_loop_time * loop_wave_frequency) * loop_wave_amplitude
	position += forward * speed * delta
	position += sideways * wave * delta
