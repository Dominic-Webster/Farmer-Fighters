extends CharacterBody2D
class_name TempEnemy

var player : Player
@onready var sprite: Sprite2D = $Sprite2D
@onready var hurt_box : Area2D = $HurtBox

@export var move_speed : float = 150
@export var damage : int = 1
@export var max_health : int = 3
var health : int = 0

var is_flashing : bool = false

var knockback_velocity := Vector2.ZERO


func _ready():
	add_to_group("enemy")
	hurt_box.add_to_group("enemy")
	health = max_health
	await_player()


func await_player() -> void:
	while RunManager.player == null:
		await get_tree().process_frame
	player = RunManager.player


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	
	var direction = (player.global_position - global_position).normalized()
	var move_velocity = direction * move_speed
	
	velocity = move_velocity + knockback_velocity
	knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * _delta)
	
	move_and_slide()


func take_damage(amount: int, from_position : Vector2):
	health -= amount
	
	var dir = (global_position - from_position).normalized()
	knockback_velocity = dir * 200
	
	flash_red()
	
	if health <= 0:
		die()


func die():
	queue_free()


func _on_hurt_box_area_entered(area):
	if area.is_in_group("player_bullet"):
		take_damage(area.damage, area.global_position)
		area.queue_free()


func flash_red():
	if is_flashing:
		return
	
	is_flashing = true
	sprite.modulate = Color(1, 0.4, 0.4) # red
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = Color(1, 1, 1) # back to normal
	is_flashing = false
