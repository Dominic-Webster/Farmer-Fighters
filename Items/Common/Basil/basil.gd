# Boosts Projectile Speed
extends Item
class_name Basil

var proj_speed_boost : float = 200


func get_item_desc() -> String:
	return "+200 Bullet Speed"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Basil"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.bullet_speed += proj_speed_boost
		if MetaManager != null:
			MetaManager.record_item_pickup("basil")
		queue_free()
		picked_up.emit(item_name, get_item_desc())
