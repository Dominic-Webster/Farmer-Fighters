# Bullets Poison Enemies
extends Item
class_name TobaccoLeaf

var poison_damage_buff : float = 2.0


func get_item_desc() -> String:
	if RunManager.player.poison_bullets == false:
		return "Bullets Poison Enemies"
	
	return "+2 Poison Damage"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Tobacco Leaf"
		RunManager.player.add_item_to_array(item_name)
		
		if RunManager.player.poison_bullets == false:
			RunManager.player.poison_bullets = true
		else:
			RunManager.player.poison_damage += poison_damage_buff
		
		if MetaManager != null:
			MetaManager.record_item_pickup("tobacco_leaf")
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
