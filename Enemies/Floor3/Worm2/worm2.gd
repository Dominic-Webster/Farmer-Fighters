extends Enemy
class_name Worm2

var direction: Vector2 = Vector2.DOWN

func _ready():
	super._ready()
	if randi_range(1, 2) == 1:
		direction = Vector2.UP


func _physics_process(_delta: float) -> void:
	if direction.y < 0:
		sprite.flip_v = false
	else:
		sprite.flip_v = true
	
	velocity = direction * move_speed
	
	move_and_slide()

	if is_on_floor() or is_on_ceiling():
		direction.y *= -1


func die():
	if not is_dead:
		died.emit()
		is_dead = true
		hurt_box.set_deferred("monitoring", false)
		move_speed = 0
		anim.stop()
		anim.play("die")
		await anim.animation_finished
		queue_free()
