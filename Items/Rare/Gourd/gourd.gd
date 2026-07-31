# Damage up, move speed down
extends Item
class_name Gourd

var damage_buff : float = 5.0
var speed_debuff : float = 0.75


func get_item_desc() -> String:
	return "+5 Damage\nMovement Speed Debuff"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Gourd"
		
		RunManager.player.damage += damage_buff
		RunManager.player.move_speed *= speed_debuff
		
		RunManager.player.add_item_to_array(item_name)
		
		if MetaManager != null:
			MetaManager.record_item_pickup("gourd")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
