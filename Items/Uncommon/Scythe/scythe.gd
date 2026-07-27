# Unlocks dash, or boosts dash damage and damage mult
extends Item
class_name Scythe

var dash_damage_buff : float = 2
var damage_mult_buff : float = 0.1


func get_item_desc() -> String:
	if RunManager.player.dash_unlocked == false:
		return "Unlock Dash\n+2 Dash Damage"
	
	return "+2 Dash Damage\n+0.1 Damage Mult"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Scythe"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.dash_unlocked == false:
			RunManager.player.dash_unlocked = true
			RunManager.player.dash_damage += dash_damage_buff
		else:
			RunManager.player.dash_damage += dash_damage_buff
			RunManager.player.damage_mult += damage_mult_buff
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
