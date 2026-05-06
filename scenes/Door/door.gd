extends Node2D
class_name  Door

@onready var collider : StaticBody2D = $StaticBody2D
@onready var art : Sprite2D = $Sprite2D
@onready var anim : AnimationPlayer = $AnimationPlayer


func lock_door():
	collider.set_collision_layer_value(5, true)
	art.frame = 0


func unlock_door():
	collider.set_collision_layer_value(5, false)
	anim.play("door_open")


func spawn_open():
	collider.set_collision_layer_value(5, false)
	art.frame = 3
