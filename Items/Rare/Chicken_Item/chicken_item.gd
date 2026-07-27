# Unlocks Cow companion, or boosts cow damage
extends Item
class_name ChickenItem

var comp_dmg_mult_boost : float = 0.25
var chicken_dmg_boost : float = 1.0
var chicken_fire_rate_boost : float = 0.1


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.chicken_unlocked == true:
		return "+1 Chicken Damage\n0.1 Chicken Fire Rate Buff\n+0.25 Companion Damage Mult"

	return "Unlock Chicken Companion"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Chicken"
		
		if RunManager.player.chicken_unlocked == true:
			
			RunManager.player.chicken_damage += chicken_dmg_boost
			RunManager.player.companion_dmg_mult += comp_dmg_mult_boost
			RunManager.player.chicken_fire_rate -= chicken_fire_rate_boost
			if RunManager.player.chicken_fire_rate < 0.05:
				RunManager.player.chicken_fire_rate = 0.05
		
		else:
			RunManager.player.chicken_unlocked = true
		
		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, get_item_desc())
