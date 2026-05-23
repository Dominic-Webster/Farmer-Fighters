extends Item
class_name Lettuce

@export var damage_mult_buff : float = 1.5


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Lettuce"
		desc = "+ Damage Mult"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.damage_mult *= damage_mult_buff
		
		queue_free()
		picked_up.emit(item_name, desc)
