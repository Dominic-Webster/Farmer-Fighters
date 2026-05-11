extends PickUp
class_name Heart

var health : int = 2

func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		if RunManager.player.current_health < RunManager.player.max_health:
			RunManager.player.heal(health)
			queue_free()
			picked_up.emit()
