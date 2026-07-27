# Boosts damage
extends Item
class_name Cauliflower

var damage_boost : float = 1.0


func get_item_desc() -> String:
	return "+1 Damage"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Cauliflower"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.damage += damage_boost
		queue_free()
		picked_up.emit(item_name, get_item_desc())
