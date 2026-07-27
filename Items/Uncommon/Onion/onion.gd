# Unlocks Piercing Bullets, or boosts damage mult
extends Item
class_name Onion

var damage_mult_buff : float = 1.0
var accuracy_buff : float = 0.005


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.piercing == false:
		return "Unlock Piercing Bullets\n0.005 Accuracy Buff"

	return "+1 Damage Mult\n0.005 Accuracy Buff"

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Onion"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.piercing == false:
			RunManager.player.piercing = true
		else:
			RunManager.player.damage_mult += damage_mult_buff
		
		RunManager.player.accuracy.x += accuracy_buff
		if RunManager.player.accuracy.x > 0:
			RunManager.player.accuracy.x = 0
		
		RunManager.player.accuracy.y -= accuracy_buff
		if RunManager.player.accuracy.y < 0:
			RunManager.player.accuracy.y = 0
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
