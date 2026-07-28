# Boosts Damage
extends Item
class_name Acorn

var damage_boost : float = 0.5


func get_item_desc() -> String:
	return "+0.5 Damage"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Acorn"
		RunManager.player.add_item_to_array(item_name)
		if MetaManager != null:
			MetaManager.record_item_pickup("acorn")
		RunManager.player.damage += damage_boost
		queue_free()
		picked_up.emit(item_name, get_item_desc())
