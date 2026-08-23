extends Node2D
class_name PoisonBubble

@onready var sprite: Sprite2D = $Sprite2D

var lifetime: float = 0.0
var elapsed: float = 0.0
var rise_speed: float = 0.0
var wave_amplitude: float = 0.0
var wave_frequency: float = 0.0
var wave_phase: float = 0.0
var base_x: float = 0.0

func _ready() -> void:
	lifetime = randf_range(0.5, 1.2)
	rise_speed = randf_range(25.0, 75.0)
	wave_amplitude = randf_range(3.0, 9.0)
	wave_frequency = randf_range(8.0, 14.0)
	wave_phase = randf_range(0.0, TAU)
	base_x = global_position.x

	if sprite != null:
		sprite.modulate.a = 0.9


func _process(delta: float) -> void:
	elapsed += delta
	if elapsed >= lifetime:
		queue_free()
		return

	global_position.y -= rise_speed * delta
	global_position.x = base_x + sin((elapsed * wave_frequency) + wave_phase) * wave_amplitude

	if sprite != null:
		var progress := clampf(elapsed / lifetime, 0.0, 1.0)
		sprite.modulate.a = lerpf(0.9, 0.0, progress)
