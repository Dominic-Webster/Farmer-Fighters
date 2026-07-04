# Boosts bullet speed
extends Item
class_name Fertilizer

var speed_boost : int = 200


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Fertilizer"
		desc = "+ Bullet Speed"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.bullet_speed += speed_boost
		queue_free()
		picked_up.emit(item_name, desc)
