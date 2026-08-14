# Boosts damage
extends Item
class_name StrawHat

var damage_boost : float = 2.5


func get_item_desc() -> String:
	if RunManager.player.shield_unlocked:
		return "+2.5 Damage"
	
	return "Unlock Shield"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Straw Hat"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.shield_unlocked:
			RunManager.player.damage += damage_boost
			if RunManager.player.shield_on == false:
				RunManager.player.shield_on = true
				RunManager.player._show_shield()
		else:
			RunManager.player.shield_unlocked = true
			RunManager.player.shield_on = true
			RunManager.player._show_shield()
		
		if MetaManager != null:
			MetaManager.record_item_pickup("straw_hat")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
