# Upgrades hearts into Carrots, and gives a health boost if already upgraded
extends Item
class_name Carrot

var health_boost : int = 3


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Carrot"
		if RunManager.player.current_heart == RunManager.player.Hearts.CARROT:
			desc = "+ Health"
			RunManager.player.add_item_to_array(item_name)
			RunManager.player.num_hearts += 1
			RunManager.player.current_health = RunManager.player.get_max_health()
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
