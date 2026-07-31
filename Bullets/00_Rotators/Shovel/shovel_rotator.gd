extends CharacterBody2D
class_name ShovelRotator

@onready var sprite : Sprite2D = $Sprite2D
@onready var hurt_box : Area2D = $HurtBox
@onready var anim : AnimationPlayer = $AnimationPlayer

var player : Player
var damage : float = 4.0
@export var orbit_radius : float = 150.0
@export var orbit_speed : float = 2.75
var orbit_angle : float = 0.0


func _ready() -> void:
	add_to_group("rotators")
	hurt_box.add_to_group("rotators")
	await_player()

	if player == null:
		queue_free()
		return

	anim.stop()
	sprite.rotation = 0.0

	if global_position == player.global_position:
		global_position = player.global_position + Vector2.RIGHT * orbit_radius

	orbit_angle = (global_position - player.global_position).angle()
	damage = player.shovel_damage


func _physics_process(delta: float) -> void:
	if player == null or not is_instance_valid(player):
		queue_free()
		return

	damage = player.shovel_damage
	orbit_angle = wrapf(orbit_angle + orbit_speed * delta, 0.0, TAU)

	var orbit_offset := Vector2.RIGHT.rotated(orbit_angle) * orbit_radius
	global_position = player.global_position + orbit_offset
	rotation = orbit_offset.angle() + PI / 2.0
	sprite.rotation = 0.0


func await_player() -> void:
	while RunManager.player == null:
		await get_tree().process_frame

	player = RunManager.player
