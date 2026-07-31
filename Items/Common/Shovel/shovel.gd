# Unlock Spinning Shovel, or Upgrade Shovel Damage
extends Item
class_name Shovel

var damage_boost : int = 3


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.shovel_unlocked == true:
		return "+3 Shovel Damage"
	
	return "Unlock Shovel: 4 Damage"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Shovel"
		
		if RunManager.player != null and RunManager.player.shovel_unlocked == true:
			RunManager.player.shovel_damage += damage_boost
		else:
			RunManager.player.shovel_unlocked = true
		
		if MetaManager != null:
			MetaManager.record_item_pickup("shovel")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
