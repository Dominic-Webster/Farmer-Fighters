# Massive buff, but inverse controls
extends Item
class_name Mirror

var health_boost : int = 2
var damage_boost : float = 2.0
var damage_mult_boost : float = 0.5
var luck_boost : int = 2


func get_item_desc() -> String:
	if RunManager.player != null and RunManager.player.inverse_controls == true:
		return "Fortune favors the Bold..."

	return "Strength at a price..."


func _ready() -> void:
	super._ready()
	if RunManager.player.current_heart == RunManager.player.Hearts.CARROT:
		health_boost = 3


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Mirror"
		RunManager.player.add_item_to_array(item_name)
		
		RunManager.player.inverse_controls = !RunManager.player.inverse_controls
		
		RunManager.player.damage += damage_boost
		RunManager.player.damage_mult += damage_mult_boost
		
		RunManager.player.luck += luck_boost
		
		RunManager.player.num_hearts += 1
		RunManager.player.current_health = RunManager.player.get_max_health()
		RunManager.player.healed.emit()
		
		queue_free()
		picked_up.emit(item_name, get_item_desc())
