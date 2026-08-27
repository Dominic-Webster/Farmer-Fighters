extends CharacterBody2D
class_name Player

# -------
# Signals
# -------

signal damaged
signal healed #Use this to avoid screen shake when not needed
signal died

# ------
# Data
# ------

@export var data : PlayerData

# ----------
# Variables
# ----------

var char_name : String = "Farmer"

# Stats
var num_hearts : int = 3 # Number of hearts
var starting_avacados : int = 0
var damage : float = 1.0
var damage_mult : float = 1.0
var luck : int = 1
var move_speed : float = 400
var fire_rate : float = 0.3
var bullet_speed : float = 800
var accuracy : Vector2 = Vector2(-0.05, 0.05)
@export var tri_shot_spread_degrees : float = 12.0

var shield_unlocked : bool = false
var shield_on : bool = false

var explosion_damage : float = 2.0
var explosion_damage_mult : float = 1.0

# Dash Stats
var dash_unlocked = false
var dash_speed : float = 2500
var dash_duration : float = 0.1
var dash_damage : float = 0
var dash_cooldown_time: float = 0.5

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
var temp_health : int = 0


func get_max_health() -> int:
	return num_hearts * get_heart_value()


var items : Array[String] = []

var active_item_id : String = ""
var active_item_name : String = ""
var active_item_desc : String = ""
var active_item_texture : Texture2D = null
var active_item_texture_path : String = ""
var active_item_charges : int = 0
var active_item_max_charges : int = 0

# Damage cooldown
var can_take_damage : bool = true

# Shooting Variables
@onready var timer : Timer = $Timer
@onready var shoot_point : Marker2D = $ShootPoint
@onready var shoot_point_2 : Marker2D = $ShootPoint2
@onready var sprite : Sprite2D = $Sprite2D
@onready var shield_sprite : Sprite2D = $Shield
@onready var hurt_box : Area2D = $HurtBox
var can_shoot : bool = true
var movement_locked : bool = false

enum Bullets {
	TOMATO,
	CABBAGE,
	BANANA,
	CORN,
	GRAPE,
	STRAWBERRY,
	PEACH,
	POTATO,
	PLANTAIN,
	PUMPKIN,
	WATERMELON
}

var current_bullet : Bullets = Bullets.TOMATO

var tomato_bullet = preload("res://Bullets/Tomato_Bullet/tomato_bullet.tscn")
var grape_bullet = preload("res://Bullets/Grape_Bullet/grape_bullet.tscn")
var banana_bullet = preload("res://Bullets/Banana_Bullet/banana_bullet.tscn")
var cabbage_bullet = preload("res://Bullets/Cabbage_Bullet/cabbage_bullet.tscn")
var corn_bullet = preload("res://Bullets/Corn_Bullet/corn_bullet.tscn")
var potato_bullet = preload("res://Bullets/Potato_Bullet/potato_bullet.tscn")
var peach_bullet = preload("res://Bullets/Peach_Bullet/peach_bullet.tscn")
var plantain_bullet = preload("res://Bullets/Plantain_Bullet/plantain_bullet.tscn")
var pumpkin_bullet = preload("res://Bullets/Pumpkin_Bullet/pumpkin_bullet.tscn")
var strawberry_bullet = preload("res://Bullets/Strawberry_Bullet/strawberry_bullet.tscn")
var watermelon_bullet = preload("res://Bullets/Watermelon_Bullet/watermelon_bullet.tscn")
var orbit_point = preload("res://Bullets/Orbit/OrbitPoint.tscn")

# Knockback
var knockback_strength := 350
var knockback_decay := 800
var knockback_velocity := Vector2.ZERO
var magnet_pull_velocity := Vector2.ZERO

# Extra
var is_flashing : bool = false

var boomerang : bool = false
var bounce : int = 0
var spiral : bool = false
var eggplant : int = 0
var cherry : bool = false
var homing : bool = false
var piercing : bool = false
var dual_shot : bool = false
var tri_shot : bool = false
var quad_shot : bool = false
var five_shot : bool = false
var portobello : bool = false
var backshot : bool = false
var explosion : bool = false
var orbit : bool = false
var inverse_controls : bool = false

var companion_dmg_mult : float = 1.0
var cow_unlocked : bool = false
var cow_damage : float = 2.0
var cow_speed : float = 250.0
var chicken_unlocked : bool = false
var chicken_damage : float = 2.0
var chicken_fire_rate : float = 0.8
var chicken_bullet_speed : float = 500

# Rotators
var shovel_unlocked : bool = false
var shovel_damage : float = 4.0
var garden_fork_unlocked : bool = false
var garden_fork_damage : float = 5.0
var trowel_unlocked : bool = false
var trowel_damage : float = 5.0

var slow_bullets : bool = false
var poison_bullets : bool = false
var poison_damage : float = 2.0
var stream : bool = false
var stream_settings : Dictionary = {
	"stream_max_length": 5000.0,
	"stream_width": 20.0,
	"stream_color": Color(0.882, 0.216, 0.196, 0.902),
	"stream_wave_amplitude": 40.0,
	"stream_wave_speed": 8.0,
	"stream_wave_segments": 24,
	"stream_wave_spatial_frequency": TAU * 2.0,
	"stream_extend_time": 0.18,
	"stream_spiral_speed": 4.0,
	"stream_homing_strength": 8.0,
	"stream_homing_range": 600.0,
}
var stream_beam_scene := preload("res://Bullets/STREAM/stream_beam.tscn")
var stream_beam: StreamBeam = null

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
	add_to_group("player")
	
	if RunManager.player_data != null:
		data = RunManager.player_data
	
	load_data()
	if stream:
		_ensure_stream_beam()
	current_health = get_max_health()
	
	if shield_unlocked and shield_on:
		_show_shield()
	else:
		_hide_shield()


func load_data() -> void:
	if data == null:
		return
	
	char_name = data.name
	sprite.texture = data.spritesheet
	
	num_hearts = data.num_hearts
	starting_avacados = data.starting_avacados
	temp_health = starting_avacados * 2
	damage = data.damage
	damage_mult = data.damage_mult
	luck = data.luck
	move_speed = data.move_speed
	fire_rate = data.fire_rate
	bullet_speed = data.bullet_speed
	accuracy = data.accuracy
	
	shield_unlocked = data.shield_unlocked
	
	explosion_damage = data.explosion_damage
	explosion_damage_mult = data.explosion_damage_mult
	
	dash_unlocked = data.dash_unlocked
	dash_speed = data.dash_speed
	dash_duration = data.dash_duration
	dash_damage = data.dash_damage
	dash_cooldown_time = data.dash_cooldown_time
	
	
	match data.starting_heart:
		data.Hearts.TOMATO:
			current_heart = Hearts.TOMATO
		data.Hearts.CARROT:
			current_heart = Hearts.CARROT
	
	match data.starting_bullet:
		data.Bullets.TOMATO:
			current_bullet = Bullets.TOMATO
		data.Bullets.CABBAGE:
			current_bullet = Bullets.CABBAGE
		data.Bullets.BANANA:
			current_bullet = Bullets.BANANA
		data.Bullets.CORN:
			current_bullet = Bullets.CORN
		data.Bullets.GRAPE:
			current_bullet = Bullets.GRAPE
		data.Bullets.STRAWBERRY:
			current_bullet = Bullets.STRAWBERRY
		data.Bullets.PEACH:
			current_bullet = Bullets.PEACH
		data.Bullets.PLANTAIN:
			current_bullet = Bullets.PLANTAIN
		data.Bullets.WATERMELON:
			current_bullet = Bullets.WATERMELON
		data.Bullets.POTATO:
			current_bullet = Bullets.POTATO
		data.Bullets.PUMPKIN:
			current_bullet = Bullets.PUMPKIN
	
	knockback_strength = data.knockback_strength
	knockback_decay = data.knockback_decay
	
	boomerang = data.boomerang
	bounce = data.bounce
	spiral = data.spiral
	eggplant = data.eggplant
	cherry = data.cherry
	homing = data.homing
	piercing = data.piercing
	dual_shot = data.dual_shot
	tri_shot = data.tri_shot
	quad_shot = data.quad_shot
	five_shot = data.five_shot
	portobello = data.portobello
	backshot = data.backshot
	explosion = data.explosion
	orbit = data.orbit
	inverse_controls = data.inverse_controls
	
	companion_dmg_mult = data.companion_dmg_mult
	cow_unlocked = data.cow_unlocked
	cow_damage = data.cow_damage
	cow_speed = data.cow_speed
	chicken_unlocked = data.chicken_unlocked
	chicken_damage = data.chicken_damage
	chicken_fire_rate = data.chicken_fire_rate
	chicken_bullet_speed = data.chicken_bullet_speed
	
	shovel_unlocked = data.shovel_unlocked
	shovel_damage = data.shovel_damage
	garden_fork_unlocked = data.garden_fork_unlocked
	garden_fork_damage = data.garden_fork_damage
	trowel_unlocked = data.trowel_unlocked
	trowel_damage = data.trowel_damage
	
	slow_bullets = data.slow_bullets
	poison_bullets = data.poison_bullets
	poison_damage = data.poison_damage
	stream = data.stream

	if MetaManager != null:
		MetaManager.record_run_hearts(num_hearts)


func _physics_process(_delta):
	if movement_locked:
		velocity = Vector2.ZERO
		move_and_slide()
		return

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
		velocity = move_velocity + knockback_velocity + magnet_pull_velocity
		# Smoothly reduce knockback over time
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, knockback_decay * _delta)

	# Dash input
	if not is_dashing and dash_unlocked and dash_cooldown <= 0.0 and Input.is_action_just_pressed("dash"):
		if direction != Vector2.ZERO:
			is_dashing = true
			dash_direction = direction
			dash_time_left = dash_duration
			if MetaManager != null:
				MetaManager.record_dash()

	if Input.is_action_just_pressed("active_item"):
		use_active_item()

	# Update sprite facing
	update_sprite_facing()

	move_and_slide()


func set_movement_locked(locked: bool) -> void:
	movement_locked = locked


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
	if stream:
		_ensure_stream_beam()
		return

	if stream_beam != null and is_instance_valid(stream_beam):
		stream_beam.queue_free()
		stream_beam = null

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


func _ensure_stream_beam() -> void:
	if stream_beam != null and is_instance_valid(stream_beam):
		stream_beam.configure(stream_settings)
		return

	if stream_beam_scene == null:
		return

	stream_beam = stream_beam_scene.instantiate() as StreamBeam
	if stream_beam == null:
		return

	add_child(stream_beam)
	stream_beam.initialize(self)
	stream_beam.configure(stream_settings)


func set_stream_color(color: Color) -> void:
	stream_settings["stream_color"] = color
	if stream_beam != null and is_instance_valid(stream_beam):
		stream_beam.configure(stream_settings)


func change_stream_width(amount : float) -> void:
	stream_settings["stream_width"] *= amount
	if stream_beam != null and is_instance_valid(stream_beam):
		stream_beam.configure(stream_settings)


func shoot(direction: Vector2):
	if not can_shoot or movement_locked:
		return
		
	# Eggplant
	if eggplant > 0:
		eggplant_shoot(eggplant)
	else:
		can_shoot = false
		
		# Accuracy
		# Determine shot directions based on unlocked shot types
		var shot_count = get_shot_count()
		var dirs = get_shot_directions(direction, shot_count)
		for bdir in dirs:
			var d = bdir
			# Accuracy per bullet
			d.x += randf_range(accuracy.x, accuracy.y)
			d.y += randf_range(accuracy.x, accuracy.y)
			spawn_bullet(d)
		
		if backshot:
			direction = -direction
			var back_dirs = get_shot_directions(direction, get_shot_count())
			for bdir in back_dirs:
				var bd = bdir
				bd.x += randf_range(accuracy.x, accuracy.y)
				bd.y += randf_range(accuracy.x, accuracy.y)
				spawn_bullet(bd)
		
		timer.wait_time = fire_rate
		timer.start()
		await timer.timeout
		can_shoot = true


func spawn_bullet(direction: Vector2) -> void:
	var selected_bullet_scene: PackedScene
	match current_bullet:
		Bullets.TOMATO:
			selected_bullet_scene = tomato_bullet
		Bullets.GRAPE:
			selected_bullet_scene = grape_bullet
		Bullets.BANANA:
			selected_bullet_scene = banana_bullet
		Bullets.PLANTAIN:
			selected_bullet_scene = plantain_bullet
		Bullets.CABBAGE:
			selected_bullet_scene = cabbage_bullet
		Bullets.CORN:
			selected_bullet_scene = corn_bullet
		Bullets.POTATO:
			selected_bullet_scene = potato_bullet
		Bullets.PEACH:
			selected_bullet_scene = peach_bullet
		Bullets.PUMPKIN:
			selected_bullet_scene = pumpkin_bullet
		Bullets.STRAWBERRY:
			selected_bullet_scene = strawberry_bullet
		Bullets.WATERMELON:
			selected_bullet_scene = watermelon_bullet

	if selected_bullet_scene == null:
		return

	var bullet
	if orbit:
		bullet = orbit_point.instantiate()
		bullet.setup(selected_bullet_scene, direction)
	else:
		bullet = selected_bullet_scene.instantiate()
		bullet.direction = direction.normalized()

	bullet.global_position = shoot_point.global_position

	RunManager.current_room_instance.add_child(bullet)


func get_shot_count() -> int:
	if five_shot:
		return 5
	if quad_shot:
		return 4
	if tri_shot:
		return 3
	if dual_shot:
		return 2
	return 1


func get_shot_directions(direction: Vector2, count: int) -> Array:
	var dirs : Array = []
	if direction == Vector2.ZERO:
		dirs.append(direction)
		return dirs

	for i in range(count):
		var idx := float(i) - float(count - 1) / 2.0
		var angle_deg := idx * tri_shot_spread_degrees
		dirs.append(direction.rotated(deg_to_rad(angle_deg)).normalized())

	return dirs


func eggplant_shoot(level : int) -> void:
	can_shoot = false
	var amount : int = 4 if level == 1 else 8

	for i in range(amount):
		var base_dir := Vector2.ZERO
		match i:
			0:
				base_dir = Vector2.UP
			1:
				base_dir = Vector2.RIGHT
			2:
				base_dir = Vector2.DOWN
			3:
				base_dir = Vector2.LEFT
			4:
				base_dir = Vector2(1, 1).normalized()
			5:
				base_dir = Vector2(1, -1).normalized()
			6:
				base_dir = Vector2(-1, -1).normalized()
			7:
				base_dir = Vector2(-1, 1).normalized()

		var dirs = get_shot_directions(base_dir, get_shot_count())
		for d in dirs:
			var dd = d
			dd.x += randf_range(accuracy.x, accuracy.y)
			dd.y += randf_range(accuracy.x, accuracy.y)
			spawn_bullet(dd)

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
	if area.is_in_group("enemy") or area.is_in_group("enemy_bullet") or area.is_in_group("hazard"):
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
		
		if "start_timer" in enemy:
			enemy.start_timer = 0.5


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
	if is_dashing or not can_take_damage or amount <= 0:
		return
	
	if shield_unlocked and shield_on:
		shield_on = false
		_hide_shield()
		return
	
	can_take_damage = false

	var remaining_damage := amount
	if temp_health > 0:
		var temp_damage := mini(remaining_damage, temp_health)
		temp_health -= temp_damage
		remaining_damage -= temp_damage

	if remaining_damage > 0:
		current_health = maxi(current_health - remaining_damage, 0)
		RunManager.player_damaged_this_floor = true

	flash_red()
	damaged.emit()
	if current_health + temp_health < 1:
		player_died()
	await get_tree().create_timer(0.75).timeout
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


func equip_active_item(item_id: String, item_name: String, item_desc: String, texture_path: String, max_charges: int, initial_charges: int = -1) -> void:
	active_item_id = item_id
	active_item_name = item_name
	active_item_desc = item_desc
	active_item_texture_path = texture_path
	active_item_texture = null
	if texture_path != "":
		active_item_texture = load(texture_path) as Texture2D
	active_item_max_charges = maxi(max_charges, 0)
	if initial_charges < 0:
		active_item_charges = active_item_max_charges
	else:
		active_item_charges = clampi(initial_charges, 0, active_item_max_charges)
	update_active_item_hud()


func recharge_active_item(amount: int = 1) -> void:
	if active_item_id == "" or active_item_max_charges <= 0 or amount <= 0:
		return

	active_item_charges = mini(active_item_charges + amount, active_item_max_charges)
	update_active_item_hud()


func clear_active_item() -> void:
	active_item_id = ""
	active_item_name = ""
	active_item_desc = ""
	active_item_texture = null
	active_item_texture_path = ""
	active_item_charges = 0
	active_item_max_charges = 0
	update_active_item_hud()


func use_active_item() -> void:
	if active_item_id == "" or active_item_charges < active_item_max_charges:
		return
	
	match active_item_id:
		"fish_emulsion":
			heal(get_heart_value())
			active_item_charges = 0
			update_active_item_hud()
		"wheat":
			deal_damage_to_all_enemies(3.0 * damage * damage_mult)
			active_item_charges = 0
			update_active_item_hud()
		_:
			return


func deal_damage_to_all_enemies(amount: float) -> void:
	if amount <= 0.0:
		return

	for enemy in get_tree().get_nodes_in_group("enemy"):
		if enemy is Enemy:
			enemy.take_damage(amount, global_position)


func update_active_item_hud() -> void:
	if RunManager == null or RunManager.gui == null:
		return

	if RunManager.gui.has_method("update_active_item"):
		RunManager.gui.update_active_item(active_item_name, active_item_texture, active_item_charges, active_item_max_charges)


func heal(amount : int) -> void:
	current_health += amount
	if current_health > get_max_health():
		current_health = get_max_health()
	healed.emit()


func add_temp_health(amount : int) -> void:
	if amount <= 0:
		return

	temp_health += amount
	healed.emit()


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
		hud.update_hp(current_health, get_max_health(), heart, num_hearts, temp_health)


func _show_shield() -> void:
	shield_sprite.visible = true


func _hide_shield() -> void:
	shield_sprite.visible = false


func reset_player() -> void:
	scale = Vector2(0.75, 0.75)
	
	load_data()
	
	items = []
	clear_active_item()
	
	current_health = get_max_health()
	temp_health = starting_avacados * 2
	
	damaged.emit()
