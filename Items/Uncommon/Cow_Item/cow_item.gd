# Unlocks Cow companion, or boosts cow damage
extends Item
class_name CowItem

var comp_dmg_mult_boost : float = 0.25
var cow_dmg_boost : float = 1.0
var cow_speed_boost : float = 50


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Cow"
		
		if RunManager.player.cow_unlocked == true:
			desc = "Cow Leveled Up!"
			
			RunManager.player.cow_damage += cow_dmg_boost
			RunManager.player.companion_dmg_mult += comp_dmg_mult_boost
			RunManager.player.cow_speed += cow_speed_boost
		
		else:
			desc = "Cow Unlocked!"
			RunManager.player.cow_unlocked = true
		
		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, desc)
