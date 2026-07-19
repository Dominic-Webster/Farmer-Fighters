extends CharacterBody2D
class_name Enemy

signal died

var player : Player
@onready var sprite: Sprite2D = $Sprite2D
@onready var hurt_box : Area2D = $HurtBox
@onready var anim : AnimationPlayer = $AnimationPlayer

@export var enemy_data : EnemyData

var weight : int = 1

var move_speed : float = 150
var damage : int = 1
var max_health : float = 3
var health : float = 0

var is_flashing : bool = false
var is_dead : bool = false

var knockback_velocity := Vector2.ZERO

enum STATUS {
	SLOW
}

var status_effects : Array[STATUS] = []


func _ready():
	if not enemy_data == null:
		max_health = enemy_data.health
		damage = enemy_data.damage
		move_speed = enemy_data.move_speed
	
	add_to_group("enemy")
	hurt_box.add_to_group("enemy")
	health = max_health
	await_player()


func await_player() -> void:
	while RunManager.player == null:
		await get_tree().process_frame
	player = RunManager.player


#func _physics_process(_delta: float) -> void:
	#if player == null:
		#return
	#
	#var direction = (player.global_position - global_position).normalized()
	#var move_velocity = direction * move_speed
	#
	#velocity = move_velocity + knockback_velocity
	#knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * _delta)
	#
	#move_and_slide()


func take_damage(amount: float, from_position : Vector2):
	health -= amount
	
	var dir = (global_position - from_position).normalized()
	knockback_velocity = dir * 200
	
	flash_red()
	
	if health <= 0:
		die()


func die():
	if not is_dead:
		is_dead = true
		died.emit()
		queue_free()


func _on_hurt_box_area_entered(area):
	if area.is_in_group("player_bullet"):
		take_damage(area.damage, area.global_position)
		
		if RunManager.player.slow_bullets == true:
			apply_status("slow")
		
		if RunManager.player and not RunManager.player.piercing:
			if area.has_method("end_bullet"):
				area.end_bullet()
			else:
				area.queue_free()
	
	if area.is_in_group("companion"):
		take_damage(area.get_parent().damage, area.global_position)


func flash_red():
	if is_flashing:
		return
	
	is_flashing = true
	sprite.modulate = Color(1, 0.4, 0.4) # red
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1) # back to normal
	is_flashing = false


func apply_status(status : String):
	match status:
		"slow":
			if not status_effects.has(STATUS.SLOW):
				status_effects.append(STATUS.SLOW)
				move_speed /= 2


func remove_status(status : String):
	match status:
		"slow":
			if status_effects.has(STATUS.SLOW):
				status_effects.erase(STATUS.SLOW)
				move_speed *= 2
