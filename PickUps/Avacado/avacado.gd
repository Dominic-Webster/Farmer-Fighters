extends PickUp
class_name Avacado


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		pickup_name = "Avacado"
		desc = "+2 Temporary Health"
		RunManager.player.add_temp_health(2)
		queue_free()
		picked_up.emit(pickup_name, desc)
