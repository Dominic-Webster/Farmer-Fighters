# Gives player another heart
extends Item
class_name Water

var health_boost : int = 2


func _ready() -> void:
	add_to_group("item")
	area2d.body_entered.connect(_on_body_entered)
	if RunManager.player.current_heart == RunManager.player.Hearts.CARROT:
		health_boost = 3


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		item_name = "Water"
		desc = "+ Health"
		RunManager.player.add_item_to_array(item_name)
		RunManager.player.num_hearts += 1
		RunManager.player.current_health = RunManager.player.get_max_health()
		RunManager.player.damaged.emit()
		queue_free()
		picked_up.emit(item_name, desc)
