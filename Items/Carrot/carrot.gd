extends Item
class_name Carrot

var health_boost : int = 3


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Carrot"
		if RunManager.player.current_heart == RunManager.player.Hearts.CARROT:
			desc = "+ Health"
			RunManager.player.add_item_to_array(item_name)
			RunManager.player.max_health += health_boost
			RunManager.player.current_health += health_boost
			RunManager.player.damaged.emit()
			queue_free()
			picked_up.emit(item_name, desc)
		else:
			desc = "Hearts become Carrots"
			RunManager.player.add_item_to_array(item_name)
			RunManager.player.upgrade_hearts_to_carrot()
			RunManager.player.damaged.emit()
			queue_free()
			picked_up.emit(item_name, desc)
