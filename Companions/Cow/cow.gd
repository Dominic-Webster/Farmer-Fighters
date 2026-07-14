# Cow Companion
extends CharacterBody2D
class_name Cow

@onready var sprite : Sprite2D = $Sprite2D
@onready var hurt_box : Area2D = $HurtBox

var switch_time : Vector2 = Vector2(0.9, 1.5)
var switch_timer : float = 0.2
var direction : Vector2 = Vector2.ZERO

var damage : float = 2.0
var move_speed : float = 250.0


func _ready():
	add_to_group("companion")
	hurt_box.add_to_group("companion")
	var player = RunManager.player
	
	damage = player.cow_damage * player.companion_dmg_mult
	move_speed = player.cow_speed


func _physics_process(_delta: float) -> void:
	if RunManager.player == null:
		return
	
	switch_timer -= _delta
	if switch_timer <= 0:
		switch_timer = randf_range(switch_time.x, switch_time.y)
		direction = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized()
		if(randi_range(1, 5) == 1):
			direction = (RunManager.player.global_position - global_position).normalized()
		# Prevent zero direction
		if direction == Vector2.ZERO:
			direction = Vector2(1, 0)
	
	var move_velocity = direction * move_speed
	
	if direction.x > 0:
		sprite.flip_h = true
	else:
		sprite.flip_h = false
	
	velocity = move_velocity
	
	move_and_slide()
	
	if is_on_wall() or is_on_ceiling() or is_on_floor():
		direction *= -1
