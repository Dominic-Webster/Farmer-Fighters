# Boosts damage
extends Item
class_name Pineapple

var damage_boost : float = 2.0
var damage_mult_boost : float = 1.5


func get_item_desc() -> String:
	return "+2 Damage\nx1.5 Damage Mult"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Pineapple"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.damage += damage_boost
		RunManager.player.damage_mult *= damage_mult_boost
		
		if MetaManager != null:
			MetaManager.record_item_pickup("pineapple")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
