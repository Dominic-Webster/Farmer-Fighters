extends CharacterBody2D
class_name Player

# -------
# Signals
# -------

signal damaged
signal died

# ----------
# Variables
# ----------

# Stats
@export var num_hearts : int = 3 # Number of hearts
@export var damage : float = 1.0
@export var damage_mult : float = 1.0
@export var luck : int = 1
@export var move_speed : float = 400
@export var fire_rate : float = 0.3
@export var bullet_speed : float = 800
@export var accuracy : Vector2 = Vector2(-0.05, 0.05)
@export var tri_shot_spread_degrees : float = 12.0

@export var explosion_damage : float = 2.0
@export var explosion_damage_mult : float = 1.0

# Dash Stats
var dash_unlocked = false
@export var dash_speed : float = 2500
@export var dash_duration : float = 0.1
@export var dash_damage : float = 0
@export var dash_cooldown_time: float = 0.5

enum Hearts {
	TOMATO,
	CARROT
}

# Returns the health value per heart type
func get_heart_value() -> int:
	match current_heart:
		Hearts.TOMATO:
			return 2
		Hearts.CARROT:
			return 3
		_:
			return 2


var current_heart : Hearts = Hearts.TOMATO
var current_health : int = 0


func get_max_health() -> int:
	return num_hearts * get_heart_value()


var items : Array[String] = []

# Damage cooldown
var can_take_damage : bool = true

# Shooting Variables
@onready var timer : Timer = $Timer
@onready var shoot_point : Marker2D = $ShootPoint
@onready var sprite : Sprite2D = $Sprite2D
var can_shoot : bool = true

enum Bullets {
	TOMATO,
	CABBAGE,
	BANANA,
	CORN,
	GRAPE,
	STRAWBERRY,
	POTATO,
	PLANTAIN,
	WATERMELON
}

var current_bullet : Bullets = Bullets.TOMATO

var tomato_bullet = preload("res://Bullets/Tomato_Bullet/tomato_bullet.tscn")
var grape_bullet = preload("res://Bullets/Grape_Bullet/grape_bullet.tscn")
var banana_bullet = preload("res://Bullets/Banana_Bullet/banana_bullet.tscn")
var cabbage_bullet = preload("res://Bullets/Cabbage_Bullet/cabbage_bullet.tscn")
var corn_bullet = preload("res://Bullets/Corn_Bullet/corn_bullet.tscn")
var potato_bullet = preload("res://Bullets/Potato_Bullet/potato_bullet.tscn")
var plantain_bullet = preload("res://Bullets/Plantain_Bullet/plantain_bullet.tscn")
var strawberry_bullet = preload("res://Bullets/Strawberry_Bullet/strawberry_bullet.tscn")
var watermelon_bullet = preload("res://Bullets/Watermelon_Bullet/watermelon_bullet.tscn")

# Knockback
@export var knockback_strength := 350
@export var knockback_decay := 800
var knockback_velocity := Vector2.ZERO

# Extra
var is_flashing : bool = false

var boomerang : bool = false
var bounce : int = 0
var spiral : bool = false
var eggplant : int = 0
var piercing : bool = false
var zucchini : bool = false
var portobello : bool = false
var tomatillo : bool = false
var explosion : bool = false
var inverse_controls : bool = false

var slow_bullets : bool = false

# Dash function variables
var is_dashing: bool = false
var dash_direction: Vector2 = Vector2.ZERO
var dash_time_left: float = 0.0
var dash_cooldown: float = 0.0

@onready var push_area : Area2D = $PushArea

# ---------
# Functions
# ---------

func _ready() -> void:
	current_health = get_max_health()
	add_to_group("player")
	#push_area.body_entered.connect(_on_push_area_body_entered)


func _physics_process(_delta):
	var direction = Vector2.ZERO
	direction.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	direction.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	direction = direction.normalized()
	
	if inverse_controls == true:
		direction *= -1
	
	# Dash logic
	if dash_cooldown > 0.0:
		dash_cooldown -= _delta
	if is_dashing:
		velocity = dash_direction * dash_speed
		dash_time_left -= _delta
		if dash_time_left <= 0.0:
			is_dashing = false
			dash_cooldown = dash_cooldown_time
	else:
		var move_velocity = direction * move_speed
		velocity = move_velocity + knockback_velocity
		# Smoothly reduce knockback over time
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * _delta)

	# Dash input
	if not is_dashing and dash_unlocked and dash_cooldown <= 0.0 and Input.is_action_just_pressed("dash"):
		if direction != Vector2.ZERO:
			is_dashing = true
			dash_direction = direction
			dash_time_left = dash_duration

	# Update sprite facing
	update_sprite_facing()

	move_and_slide()


# Helper to set sprite frame/flip based on shoot or move direction
func update_sprite_facing():
	var shoot_dir = get_shoot_direction()
	var move_dir = Vector2.ZERO
	move_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	move_dir.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	
	if inverse_controls == true:
		move_dir *= -1
	
	move_dir = move_dir.normalized()

	var face_dir = shoot_dir if shoot_dir != Vector2.ZERO else move_dir

	if face_dir == Vector2.ZERO or face_dir.y > 0:
		sprite.frame = 0
		sprite.flip_h = false
		push_area.position.x = 0
		push_area.position.y = 56
	elif face_dir.y < 0:
		sprite.frame = 1
		sprite.flip_h = false
		push_area.position.x = 0
		push_area.position.y = 63
	elif face_dir.x > 0:
		sprite.frame = 2
		sprite.flip_h = false
		push_area.position.x = 4
		push_area.position.y = 60
	elif face_dir.x < 0:
		sprite.frame = 2
		sprite.flip_h = true
		push_area.position.x = -4
		push_area.position.y = 60


func _process(_delta):
	var shoot_dir = get_shoot_direction()
	
	if shoot_dir != Vector2.ZERO:
		shoot(shoot_dir)


func get_shoot_direction() -> Vector2:
	var dir = Vector2.ZERO
	
	dir.x = Input.get_action_strength("shoot_right") - Input.get_action_strength("shoot_left")
	dir.y = Input.get_action_strength("shoot_down") - Input.get_action_strength("shoot_up")
	
	if inverse_controls == true:
		dir *= -1
	
	return dir.normalized()


func shoot(direction: Vector2):
	if not can_shoot:
		return
		
	# Eggplant
	if eggplant > 0:
		eggplant_shoot(eggplant)
	else:
		can_shoot = false
		
		# Accuracy
		direction.x += randf_range(accuracy.x, accuracy.y)
		direction.y += randf_range(accuracy.x, accuracy.y)
		
		if zucchini:
			spawn_bullet(direction)
			spawn_bullet(create_offset(direction, -1))
			spawn_bullet(create_offset(direction, 1))
		else:
			spawn_bullet(direction)
		
		if tomatillo:
			direction = -direction
			
			if zucchini:
				spawn_bullet(direction)
				spawn_bullet(create_offset(direction, -1))
				spawn_bullet(create_offset(direction, 1))
			else:
				spawn_bullet(direction)
		
		timer.wait_time = fire_rate
		timer.start()
		await timer.timeout
		can_shoot = true


func spawn_bullet(direction: Vector2) -> void:
	var bullet
	match current_bullet:
		Bullets.TOMATO:
			bullet = tomato_bullet.instantiate()
		Bullets.GRAPE:
			bullet = grape_bullet.instantiate()
		Bullets.BANANA:
			bullet = banana_bullet.instantiate()
		Bullets.PLANTAIN:
			bullet = plantain_bullet.instantiate()
		Bullets.CABBAGE:
			bullet = cabbage_bullet.instantiate()
		Bullets.CORN:
			bullet = corn_bullet.instantiate()
		Bullets.POTATO:
			bullet = potato_bullet.instantiate()
		Bullets.STRAWBERRY:
			bullet = strawberry_bullet.instantiate()
		Bullets.WATERMELON:
			bullet = watermelon_bullet.instantiate()

	bullet.global_position = shoot_point.global_position
	bullet.direction = direction.normalized()

	RunManager.current_room_instance.add_child(bullet)


func eggplant_shoot(level : int) -> void:
	can_shoot = false
	var amount : int
	if level == 1:
		amount = 4
	else:
		amount = 8
	
	for i in range(amount):
		var bullet
		match current_bullet:
			Bullets.TOMATO:
				bullet = tomato_bullet.instantiate()
			Bullets.GRAPE:
				bullet = grape_bullet.instantiate()
			Bullets.BANANA:
				bullet = banana_bullet.instantiate()
			Bullets.PLANTAIN:
				bullet = plantain_bullet.instantiate()
			Bullets.CABBAGE:
				bullet = cabbage_bullet.instantiate()
			Bullets.CORN:
				bullet = corn_bullet.instantiate()
			Bullets.POTATO:
				bullet = potato_bullet.instantiate()
			Bullets.STRAWBERRY:
				bullet = strawberry_bullet.instantiate()
			Bullets.WATERMELON:
				bullet = watermelon_bullet.instantiate()
		
		bullet.global_position = shoot_point.global_position
		
		match i:
			0:
				bullet.direction = Vector2.UP
			1:
				bullet.direction = Vector2.RIGHT
			2:
				bullet.direction = Vector2.DOWN
			3:
				bullet.direction = Vector2.LEFT
			4:
				bullet.direction = Vector2(1, 1).normalized()
			5:
				bullet.direction = Vector2(1, -1).normalized()
			6:
				bullet.direction = Vector2(-1, -1).normalized()
			7:
				bullet.direction = Vector2(-1, 1).normalized()
		# Accuracy
		bullet.direction.x += randf_range(accuracy.x, accuracy.y)
		bullet.direction.y += randf_range(accuracy.x, accuracy.y)
		
		if zucchini:
			spawn_bullet(bullet.direction)
			spawn_bullet(create_offset(bullet.direction, -1))
			spawn_bullet(create_offset(bullet.direction, 1))
		else:
			spawn_bullet(bullet.direction)
	
	timer.wait_time = fire_rate
	timer.start()
	await timer.timeout
	can_shoot = true


func create_offset(dir : Vector2, value : int) -> Vector2:
	if dir == Vector2.ZERO:
		return dir

	var spread_radians := deg_to_rad(tri_shot_spread_degrees)
	if value < 0:
		spread_radians = -spread_radians
	elif value == 0:
		spread_radians = 0.0

	return dir.rotated(spread_radians).normalized()


func _on_hurt_box_area_entered(area) -> void:
	if area.is_in_group("enemy") or area.is_in_group("enemy_bullet"):
		var dir = (global_position - area.global_position).normalized()
		knockback_velocity = dir * knockback_strength
		
		var enemy = area.get_parent()
		
		# Deal dash damage to enemy if dashing and dash_damage > 0
		if is_dashing and dash_damage > 0 and "take_damage" in enemy:
			enemy.take_damage(dash_damage, global_position)
		
		if "damage" in enemy:
			take_damage(enemy.damage)
		else:
			take_damage(1)
		
		if area.is_in_group("enemy_bullet"):
			area.queue_free()


func _on_push_area_body_entered(body):
	if body is RigidBody2D:
		# Only push if the player is moving
		if velocity.length() > 0.1:
			var push_dir = velocity.normalized()
			var crate_speed_in_dir = body.linear_velocity.dot(push_dir)
			var push_threshold = 40
			if crate_speed_in_dir < push_threshold:
				body.apply_central_impulse(push_dir * 3000) # Adjust force as needed


func take_damage(amount : int):
	if not is_dashing and can_take_damage:
		can_take_damage = false
		current_health -= amount
		flash_red()
		damaged.emit()
		if current_health < 1:
			player_died()
		await get_tree().create_timer(0.5).timeout
		can_take_damage = true


func player_died():
	died.emit()
	#queue_free()


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


func heal(amount : int) -> void:
	current_health += amount
	if current_health > get_max_health():
		current_health = get_max_health()
	damaged.emit()


func upgrade_hearts_to_carrot():
	if current_heart != Hearts.CARROT:
		var old_heart_value = 2
		var new_heart_value = 3
		var old_health = current_health
		var old_max_health = num_hearts * old_heart_value
		current_heart = Hearts.CARROT
		var health_ratio = float(old_health) / float(old_max_health)
		current_health = int(round(health_ratio * (num_hearts * new_heart_value)))
		update_hp()
		damaged.emit()


# Always update HUD with current heart type
func update_hp():
	var hud = null
	for node in get_tree().get_nodes_in_group("player_hud"):
		hud = node
		break
	if hud:
		var heart : int
		match current_heart:
			Hearts.TOMATO :
				heart = 0
			Hearts.CARROT :
				heart = 1
		hud.update_hp(current_health, get_max_health(), heart, num_hearts)


func reset_player() -> void:
	num_hearts = 3
	damage = 1.0
	damage_mult = 1.0
	luck = 1
	move_speed = 400
	fire_rate = 0.3
	bullet_speed = 800
	accuracy = Vector2(-0.05, 0.05)
	
	explosion_damage = 2.0
	explosion_damage_mult = 1.0
	
	# Dash Stats
	dash_unlocked = false
	dash_speed = 2500
	dash_duration = 0.1
	dash_damage = 0
	dash_cooldown_time = 0.5
	
	current_heart = Hearts.TOMATO
	current_health = get_max_health()
	
	items = []
	
	current_bullet = Bullets.TOMATO
	
	boomerang = false
	bounce = 0
	spiral = false
	eggplant = 0
	piercing = false
	zucchini = false
	portobello = false
	tomatillo = false
	explosion = false
	
	slow_bullets = false
