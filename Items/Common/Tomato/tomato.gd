# Upgrades hearts into Tomatoes, and gives a health boost if already upgraded
extends Item
class_name Tomato

var health_boost : int = 3


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.current_heart == RunManager.player.Hearts.TOMATO:
		return "+1 Heart"
	
	return "Hearts become Tomatoes"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Tomato"

		if MetaManager != null:
			MetaManager.record_item_pickup("tomato")

		if RunManager.player.current_heart == RunManager.player.Hearts.TOMATO:
			RunManager.player.add_item_to_array(item_name)
			RunManager.player.num_hearts += 1
			if MetaManager != null:
				MetaManager.record_run_hearts(RunManager.player.num_hearts)
			RunManager.player.current_health = RunManager.player.get_max_health()
			RunManager.player.healed.emit()
			queue_free()
			picked_up.emit(item_name, get_item_desc())
		else:
			RunManager.player.add_item_to_array(item_name)
			RunManager.player.upgrade_hearts_to_tomato()
			RunManager.player.healed.emit()
			queue_free()
			picked_up.emit(item_name, get_item_desc())
