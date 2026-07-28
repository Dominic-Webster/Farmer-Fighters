# Unlocks Cow companion, or boosts cow damage
extends Item
class_name CowItem

var comp_dmg_mult_boost : float = 0.25
var cow_dmg_boost : float = 1.5
var cow_speed_boost : float = 200


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.cow_unlocked == true:
		return "+1.5 Cow Damage\n+200 Cow Speed\n+0.25 Companion Damage Mult"

	return "Unlock Cow Companion"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Cow"
		
		if RunManager.player.cow_unlocked == true:
			
			RunManager.player.cow_damage += cow_dmg_boost
			RunManager.player.companion_dmg_mult += comp_dmg_mult_boost
			RunManager.player.cow_speed += cow_speed_boost
		
		else:
			RunManager.player.cow_unlocked = true
			if MetaManager != null:
				MetaManager.record_item_pickup("cow_item")
		
		RunManager.player.add_item_to_array(item_name)

		if MetaManager != null:
			MetaManager.record_item_pickup("cow")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
