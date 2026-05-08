extends Node2D
class_name  Door

@onready var collider : StaticBody2D = $StaticBody2D
@onready var art : Sprite2D = $Sprite2D
@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var trigger : Area2D = $Area2D

enum dir {
	UP,
	RIGHT,
	DOWN,
	LEFT
}

@export var direction : dir = dir.UP

var used : bool = false


func _ready() -> void:
	trigger.body_entered.connect(_on_body_entered)
	trigger.body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if used:
		return
	
	if not RunManager.can_trigger_doors:
		return
	
	if body == RunManager.player:
		trigger.set_deferred("monitoring", false)
		used = true
		
		RunManager.call_deferred("change_room", get_dir_string())


func get_dir_string() -> String:
	match direction:
		dir.UP: return "U"
		dir.RIGHT: return "R"
		dir.DOWN: return "D"
		dir.LEFT: return "L"
	return ""


func _on_body_exited(body):
	if body == RunManager.player:
		used = false


func lock_door():
	collider.set_collision_layer_value(5, true)
	art.frame = 0


func unlock_door():
	collider.set_collision_layer_value(5, false)
	anim.play("door_open")


func spawn_open():
	collider.set_collision_layer_value(5, false)
	art.frame = 3


func set_door_art(desc : String):
	if desc == "B":
		art.texture = load("res://scenes/Door/boss_door.png")
	if desc == "T":
		art.texture = load("res://scenes/Door/treasure_door.png")
