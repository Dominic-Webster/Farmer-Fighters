extends Enemy
class_name Magnet

const SAW_TURRET_SCENE : PackedScene = preload("res://Enemies/Floor6/Saw_Turret/Saw_Turret.tscn")
const SAW_TURRET_POSITIONS := [Vector2(250, 250), Vector2(1670, 830)]

var start_timer : float = 1.0
@export var pull_speed : float = 250.0


func _ready() -> void:
	super._ready()
	call_deferred("_spawn_saw_turrets")


func _spawn_saw_turrets() -> void:
	var room := get_parent() as Room
	if room == null:
		return

	for spawn_position in SAW_TURRET_POSITIONS:
		var saw_turret := SAW_TURRET_SCENE.instantiate()
		saw_turret.global_position = spawn_position
		room.add_child(saw_turret)
		room.enemy_count += saw_turret.weight
		saw_turret.died.connect(func(): room._on_enemy_died(saw_turret))


func _physics_process(_delta : float) -> void:
	if player == null or is_dead:
		if player != null:
			player.magnet_pull_velocity = Vector2.ZERO
		return
	
	var direction := (player.global_position - global_position).normalized()
	sprite.rotation = direction.angle() + PI / 2
	
	if start_timer > 0:
		start_timer -= _delta
		velocity = Vector2.ZERO
		player.magnet_pull_velocity = Vector2.ZERO
	else:
		player.magnet_pull_velocity = (global_position - player.global_position).normalized() * pull_speed


func die():
	if not is_dead:
		died.emit()
		is_dead = true
		if player != null:
			player.magnet_pull_velocity = Vector2.ZERO
		hurt_box.set_deferred("monitoring", false)
		move_speed = 0
		anim.stop()
		anim.play("die")
		await anim.animation_finished
		queue_free()
