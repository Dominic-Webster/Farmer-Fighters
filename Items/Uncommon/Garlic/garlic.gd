# Unlocks Slow_Bullets, or boosts damage
extends Item
class_name Garlic

var damage_buff : float = 0.75


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.slow_bullets == true:
		return "+0.75 Damage"

	return "Bullets Slow Enemies"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Garlic"
		
		if RunManager.player.slow_bullets == true:
			RunManager.player.damage += damage_buff
		else:
			RunManager.player.slow_bullets = true
		
		RunManager.player.add_item_to_array(item_name)

		if MetaManager != null:
			MetaManager.record_item_pickup("garlic")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
