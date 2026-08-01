# Unlock Spinning Trowels, or Upgrade Trowel Damage
extends Item
class_name Trowel

var damage_boost : int = 4


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.trowel_unlocked == true:
		return "+4 Trowel Damage"
	
	return "Unlock Trowels: 5 Damage"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Trowel"
		
		if RunManager.player != null and RunManager.player.trowel_unlocked == true:
			RunManager.player.trowel_damage += damage_boost
		else:
			RunManager.player.trowel_unlocked = true
		
		if MetaManager != null:
			MetaManager.record_item_pickup("trowel")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
