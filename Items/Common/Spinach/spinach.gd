# Boosts move speed, damage, damage mult, and bullet speed
extends Item
class_name Spinach

var move_speed_boost : float = 100
var damage_boost : float = 0.5
var damage_mult_boost : float = 0.1
var proj_speed_boost : float = 150


func get_item_desc() -> String:
	return "+100 Movement Speed\n+0.5 Damage\n+0.1 Damage Mult\n+150 Bullet Speed"


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Spinach"
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.move_speed += move_speed_boost
		RunManager.player.damage += damage_boost
		RunManager.player.damage_mult += damage_mult_boost
		RunManager.player.bullet_speed += proj_speed_boost
		
		if MetaManager != null:
			MetaManager.record_item_pickup("spinach")

		queue_free()
		picked_up.emit(item_name, get_item_desc())
