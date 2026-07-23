extends Enemy
class_name Worm

var direction: Vector2 = Vector2.RIGHT

func _ready():
	super._ready()
	if randi_range(1, 2) == 1:
		direction = Vector2.LEFT


func _physics_process(_delta: float) -> void:
	if direction.x > 0:
		sprite.flip_h = false
	else:
		sprite.flip_h = true

	velocity = direction * move_speed

	move_and_slide()

	if is_on_wall():
		direction.x *= -1


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
