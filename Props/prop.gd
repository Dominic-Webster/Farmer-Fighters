extends RigidBody2D
class_name Prop

@onready var bullet_bounds : Area2D = $BulletBounds


func _ready() -> void:
	bullet_bounds.add_to_group("bullet_bounds")
	contact_monitor = true
	max_contacts_reported = 4

func _physics_process(_delta):
	for body in get_colliding_bodies():
		if body.is_in_group("wall"):
			linear_velocity = Vector2.ZERO
			angular_velocity = 0
			break
