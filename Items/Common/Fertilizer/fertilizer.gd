# Boosts bullet speed
extends Item
class_name Fertilizer

var speed_boost : int = 200


func get_item_desc() -> String:
	return "+200 Bullet Speed"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Fertilizer"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.bullet_speed += speed_boost
		
		if MetaManager != null:
			MetaManager.record_item_pickup("fertilizer")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
