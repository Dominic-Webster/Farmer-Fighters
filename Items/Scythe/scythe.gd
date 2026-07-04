# Unlocks dash, or boosts dash damage and damage mult
extends Item
class_name Scythe

var dash_damage_buff : float = 1
var damage_mult_buff : float = 0.1


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Scythe"
		desc = "Dash (+ Damage)"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dash_unlocked == false:
			RunManager.player.dash_unlocked = true
			RunManager.player.dash_damage += dash_damage_buff
		else:
			RunManager.player.dash_damage += dash_damage_buff
			RunManager.player.damage_mult += damage_mult_buff
		
		queue_free()
		picked_up.emit(item_name, desc)
