extends CharacterBody2D
class_name Chicken

@onready var sprite : Sprite2D = $Sprite2D
@onready var shoot_point : Marker2D = $ShootPoint

@export var bullet_scene : PackedScene

var direction : Vector2 = Vector2.DOWN
var action_timer : float = 1.0

var fire_rate : float = 0.8
var move_speed : float = 300

func _ready() -> void:
	add_to_group("companion")
	fire_rate = RunManager.player.chicken_fire_rate


func _physics_process(_delta: float) -> void:
	if RunManager.player == null:
		return
	
	if direction.y > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true
	
	velocity = direction * move_speed
	
	move_and_slide()

	if is_on_floor() or is_on_ceiling():
		direction.y *= -1
	
	action_timer -= _delta
	if action_timer <= 0:
		shoot()
		action_timer = fire_rate


func shoot() -> void:
	for i in 2:
		var dir : Vector2
		match i:
			0:
				dir = Vector2.RIGHT
			1:
				dir = Vector2.LEFT
		
		var egg = bullet_scene.instantiate()
		get_tree().current_scene.add_child(egg)
		egg.global_position = shoot_point.global_position
		egg.direction = dir
