# Boosts damage mult
extends Item
class_name Lettuce

@export var damage_mult_buff : float = 1.5


func get_item_desc() -> String:
	return "x1.5 Damage Mult"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Lettuce"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.damage_mult *= damage_mult_buff
		
		if MetaManager != null:
			MetaManager.record_item_pickup("lettuce")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
