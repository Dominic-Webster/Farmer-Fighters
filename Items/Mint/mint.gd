# Boosts fire rate
extends Item
class_name Mint

var fire_rate_boost : float = 0.05


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Mint"
		desc = "+ Fire Rate"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.fire_rate -= fire_rate_boost
		if RunManager.player.fire_rate < 0.01:
			RunManager.player.fire_rate = 0.01
		queue_free()
		picked_up.emit(item_name, desc)
