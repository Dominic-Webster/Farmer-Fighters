extends PickUp
class_name Heart

@onready var sprite : Sprite2D = $Sprite2D
var health : int = 2


func _ready() -> void:
	add_to_group("pickup")
	area2d.body_entered.connect(_on_body_entered)
	if RunManager.player.current_heart == RunManager.player.Hearts.TOMATO:
		health = 3
		sprite.texture = load("res://GUI/Player_HUD/Tomato_Heart.png")
		sprite.vframes = 1
		sprite.hframes = 7
		sprite.frame = 0


func _on_body_entered(_body) -> void:
	if _body.is_in_group("player"):
		pickup_name = "Heart"
		desc = "Heal"
		if RunManager.player.current_health < RunManager.player.get_max_health():
			RunManager.player.heal(health)
			queue_free()
			picked_up.emit(pickup_name, desc)
