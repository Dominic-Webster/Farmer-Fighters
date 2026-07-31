# Boosts luck and damage mult, debuffs damage
extends Item
class_name Plum

var luck_boost : int = 1
var damage_mult_buff : float = 0.35
var damage_debuff : float = 0.25


func get_item_desc() -> String:
	return "+1 Luck\n+0.35 Damage Mult\n-0.25 Damage"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Plum"
		RunManager.player.add_item_to_array(item_name)
		if MetaManager != null:
			MetaManager.record_item_pickup("plum")
		
		RunManager.player.luck += luck_boost
		RunManager.player.damage_mult += damage_mult_buff
		RunManager.player.damage -= damage_debuff
		if RunManager.player.damage < 0.25:
			RunManager.player.damage = 0.25
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
