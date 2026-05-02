extends CharacterBody2D
class_name Player

@onready var timer : Timer = $Timer
@onready var shoot_point : Marker2D = $ShootPoint

@export var speed : float = 400
@export var fire_rate : float = 0.3
var can_shoot : bool = true

@export var bullet_scene : PackedScene


func _ready() -> void:
	add_to_group("player")


func _physics_process(_delta):
	var direction = Vector2.ZERO
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	direction = direction.normalized()
	
	velocity = direction * speed
	move_and_slide()


func _process(_delta):
	var shoot_dir = get_shoot_direction()
	
	if shoot_dir != Vector2.ZERO:
		shoot(shoot_dir)


func get_shoot_direction() -> Vector2:
	var dir = Vector2.ZERO
	
	dir.x = Input.get_action_strength("shoot_right") - Input.get_action_strength("shoot_left")
	dir.y = Input.get_action_strength("shoot_down") - Input.get_action_strength("shoot_up")
	
	return dir.normalized()


func shoot(direction: Vector2):
	if not can_shoot:
		return
		
	can_shoot = false
	
	var bullet = bullet_scene.instantiate()
	bullet.global_position = shoot_point.global_position
	bullet.direction = direction
	
	get_tree().current_scene.add_child(bullet)
	
	timer.wait_time = fire_rate
	timer.start()
	await timer.timeout
	can_shoot = true
