# Boosts damage
extends Item
class_name Cauliflower

var damage_boost : float = 2.0
var damage_mult_boost : float = 1.5


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Pineapple"
		desc = "+ Damage"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.damage += damage_boost
		RunManager.player.damage_mult *= damage_mult_boost
		queue_free()
		picked_up.emit(item_name, desc)
