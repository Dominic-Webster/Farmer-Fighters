extends Area2D
class_name Explosion

@export var damage : float = 2.0

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var collision_shape : CollisionShape2D = $CollisionShape2D

var _did_damage : bool = false


func _ready() -> void:
	if RunManager.player != null:
		damage = RunManager.player.explosion_damage
	
	animation_player.play("boom")
	await animation_player.animation_finished
	_deal_damage()
	queue_free()


func _deal_damage() -> void:
	if _did_damage:
		return
	_did_damage = true

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = collision_shape.shape
	query.transform = collision_shape.global_transform
	query.collision_mask = collision_mask
	query.collide_with_areas = true
	query.collide_with_bodies = false

	var results = get_world_2d().direct_space_state.intersect_shape(query, 16)
	for result in results:
		var area = result.get("collider")
		if area != null and area.is_in_group("enemy"):
			var enemy = area.get_parent()
			if enemy != null and "take_damage" in enemy:
				enemy.take_damage(damage, global_position)
