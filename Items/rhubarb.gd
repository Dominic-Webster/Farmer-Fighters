# Boosts Damage Mult
extends Item
class_name Rhubarb

var damage_mult_boost : float = 0.5


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Rhubarb"
		desc = "+ Damage Mult"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.damage_mult += damage_mult_boost
		queue_free()
		picked_up.emit(item_name, desc)
