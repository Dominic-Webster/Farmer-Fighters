# Boosts damage mult, debuffs damage
extends Item
class_name Pear

var damage_debuff : float = 0.5
var damage_mult_boost : float = 1.0


func get_item_desc() -> String:
	return "+1 Damage Mult\n-0.5 Damage"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Pear"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.damage -= damage_debuff
		if RunManager.player.damage < 0.25:
			RunManager.player.damage = 0.25
		RunManager.player.damage_mult += damage_mult_boost
		
		if MetaManager != null:
			MetaManager.record_item_pickup("pear")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
