# Either boosts companion dmg mult or dmg mult
extends Item
class_name Haybale

var comp_dmg_mult_boost : float = 1.5
var dmg_mult_boost : float = 1.25


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.cow_unlocked == true:
		return "x1.5 Companion Damage Mult"

	return "x1.25 Damage Mult"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Haybale"
		
		if RunManager.player.cow_unlocked == true:
			RunManager.player.companion_dmg_mult *= comp_dmg_mult_boost
		
		else:
			RunManager.player.damage_mult *= dmg_mult_boost
		
		RunManager.player.add_item_to_array(item_name)
		queue_free()
		picked_up.emit(item_name, get_item_desc())
