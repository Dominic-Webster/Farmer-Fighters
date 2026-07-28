# Unlocks additional backwards bullet, or increase movement speed
extends Item
class_name Cherry

var damage_buff : float = 1.5


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.cherry == false:
		return "Enemies shoot Player Bullets on death"

	return "+1.5 Damage"

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Cherry"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.cherry == false:
			RunManager.player.cherry = true
		else:
			RunManager.player.damage += damage_buff
		
		if MetaManager != null:
			MetaManager.record_item_pickup("cherry")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
