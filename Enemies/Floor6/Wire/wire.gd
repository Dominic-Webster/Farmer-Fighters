extends Enemy
class_name Wire

var blue_sprite = preload("res://Enemies/Floor6/Wire/Blue_wire_enemy.png")
var green_sprite = preload("res://Enemies/Floor6/Wire/Green_wire_enemy.png")
var red_sprite = preload("res://Enemies/Floor6/Wire/Red_wire_enemy.png")


func _ready():
	super._ready()
	var i = randi_range(1, 3)
	match i:
		1:
			sprite.texture = blue_sprite
			max_health -= 5
			health = max_health
		2:
			sprite.texture = red_sprite
			max_health += 5
			health = max_health
		3:
			sprite.texture = green_sprite

	if anim != null and anim.has_animation("move"):
		var move_length := anim.get_animation("move").length
		if move_length > 0.0:
			anim.seek(randf_range(0.0, move_length), true)


func die():
	if not is_dead:
		died.emit()
		is_dead = true
		hurt_box.set_deferred("monitoring", false)
		move_speed = 0
		anim.stop()
		anim.play("die")
		await anim.animation_finished
		cherry_shot()
		queue_free()
