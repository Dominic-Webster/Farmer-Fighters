extends CharacterBody2D
class_name TempEnemy

@onready var player = get_tree().get_first_node_in_group("player")

@export var move_speed : float = 100
@export var max_health : int = 3
var health : int = 0

func _ready():
	health = max_health


func _physics_process(_delta: float) -> void:
	if player == null:
		return
	
	var direction = (player.global_position - global_position).normalized()
	
	velocity = direction * move_speed
	move_and_slide()


func take_damage(amount: int):
	health -= amount
	
	if health <= 0:
		die()


func die():
	queue_free()


func _on_hurt_box_area_entered(area):
	if area.is_in_group("player_bullet"):
		take_damage(1)
		area.queue_free()
