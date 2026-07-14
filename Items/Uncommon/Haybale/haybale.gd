# Either boosts companion dmg mult or dmg mult
extends Item
class_name Haybale

var comp_dmg_mult_boost : float = 0.5
var dmg_mult_boost : float = 0.25


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Haybale"
		
		if RunManager.player.cow_unlocked == true:
			desc = "+ Companion Damage Mult"
			RunManager.player.companion_dmg_mult += comp_dmg_mult_boost
		
		else:
			desc = "+ Damage Mult"
			RunManager.player.damage_mult += dmg_mult_boost
		
		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, desc)
