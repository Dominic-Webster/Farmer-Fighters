# Boosts Projectile Speed
extends Item
class_name Basil

var proj_speed_boost : float = 200


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Basil"
		desc = "+ Projectile Speed"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.bullet_speed += proj_speed_boost
		queue_free()
		picked_up.emit(item_name, desc)
