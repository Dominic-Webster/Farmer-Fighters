extends PickUp
class_name Heart

@onready var sprite : Sprite2D = $Sprite2D
var health : int = 2


func _ready() -> void:
	add_to_group("pickup")
	area2d.body_entered.connect(_on_body_entered)
	if RunManager.player.current_heart == RunManager.player.Hearts.CARROT:
		health = 3
		sprite.texture = load("res://GUI/Player_HUD/carrot_health.png")
		sprite.vframes = 2
		sprite.hframes = 2
		sprite.frame = 3


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		pickup_name = "Heart"
		desc = "Heal"
		if RunManager.player.current_health < RunManager.player.get_max_health():
			RunManager.player.heal(health)
			queue_free()
			picked_up.emit(pickup_name, desc)
