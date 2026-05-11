extends CharacterBody2D
class_name Player

signal damaged

@onready var timer : Timer = $Timer
@onready var shoot_point : Marker2D = $ShootPoint
@onready var sprite : Sprite2D = $Sprite2D

@export var max_health : int = 6
var current_health : int

@export var move_speed : float = 400
@export var fire_rate : float = 0.3
var can_shoot : bool = true
var is_flashing : bool = false

@export var bullet_scene : PackedScene

var knockback_velocity := Vector2.ZERO
@export var knockback_strength := 350
@export var knockback_decay := 800

var items : Array[String] = []


func _ready() -> void:
	current_health = max_health
	add_to_group("player")


func _physics_process(_delta):
	var direction = Vector2.ZERO
	
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	direction = direction.normalized()
	
	var move_velocity = direction * move_speed
	
	# Apply Knockback
	velocity = move_velocity + knockback_velocity
	
	# Smoothly reduce knockback over time
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * _delta)
	
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
	
	RunManager.current_room_instance.add_child(bullet)
	
	timer.wait_time = fire_rate
	timer.start()
	await timer.timeout
	can_shoot = true


func _on_hurt_box_area_entered(area) -> void:
	if area.is_in_group("enemy"):
		var dir = (global_position - area.global_position).normalized()
		knockback_velocity = dir * knockback_strength
		
		var enemy = area.get_parent()
		if "damage" in enemy:
			take_damage(enemy.damage)
		else:
			take_damage(1)


func take_damage(amount : int):
	current_health -= amount
	flash_red()
	damaged.emit()
	
	if current_health < 1:
		player_died()


func player_died():
	queue_free()


func flash_red():
	if is_flashing:
		return
	
	is_flashing = true
	sprite.modulate = Color(1, 0.4, 0.4) # red
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1) # back to normal
	is_flashing = false


func add_item_to_array(item : String) -> void:
	if item != "":
		items.append(item)
