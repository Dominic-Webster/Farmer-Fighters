# Unlock Spinning Garden Fork, or Upgrade Garden Fork Damage
extends Item
class_name GardenFork

var damage_boost : int = 4


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.garden_fork_unlocked == true:
		return "+4 Garden Fork Damage"
	
	return "Unlock Garden Fork: 5 Damage"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Garden Fork"
		
		if RunManager.player != null and RunManager.player.garden_fork_unlocked == true:
			RunManager.player.garden_fork_damage += damage_boost
		else:
			RunManager.player.garden_fork_unlocked = true
		
		if MetaManager != null:
			MetaManager.record_item_pickup("garden_fork")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
