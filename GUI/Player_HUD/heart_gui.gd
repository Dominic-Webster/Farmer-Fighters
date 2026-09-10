extends Control
class_name HeartGUI

enum DisplayKind {
	BASE,
	TEMP
}

@onready var sprite: Sprite2D = $Sprite2D

var heart_num : int = 2

var value : int = 2
var heart_type : int = 0 # 0 = CARROT, 1 = TOMATO
var display_kind : DisplayKind = DisplayKind.BASE
var has_displayed_value := false
var damage_animation_id := 0

func _ready() -> void:
	sprite.scale = Vector2(1.5, 1.5)


func set_heart(_value: int, _heart_type: Variant = null, _display_kind: Variant = null) -> void:
	var previous_value := value
	value = _value
	if _heart_type != null:
		heart_type = int(_heart_type)
	if _display_kind != null:
		display_kind = _display_kind as DisplayKind
	update_sprite()
	if has_displayed_value and display_kind == DisplayKind.BASE and value < previous_value:
		play_damage_animation(previous_value)
	has_displayed_value = true


func update_sprite() -> void:
	var tex = null
	var _scale : float = 2.5
	if display_kind == DisplayKind.TEMP:
		tex = preload("res://GUI/Player_HUD/Avacado.png")
		_scale = 4.75
		sprite.hframes = 2
		sprite.vframes = 1
		if value <= 0:
			sprite.visible = false
			return
		sprite.frame = 0 if value >= 2 else 1
		if sprite.texture != tex:
			sprite.texture = tex
			sprite.scale = Vector2(_scale, _scale)
		sprite.visible = true
		return

	match RunManager.player.current_heart:
		RunManager.player.Hearts.CARROT:
			tex = preload("res://GUI/Player_HUD/Carrot_Heart.png")
			_scale = 1.5
			sprite.hframes = 9
			sprite.vframes = 2
		RunManager.player.Hearts.TOMATO:
			tex = preload("res://GUI/Player_HUD/Tomato_Heart.png")
			_scale = 1.5
			sprite.hframes = 7
			sprite.vframes = 1
	if sprite.texture != tex:
		sprite.texture = tex
		sprite.scale = Vector2(_scale, _scale)
	sprite.frame = (3 - value) * 2 if RunManager.player.current_heart == RunManager.player.Hearts.TOMATO else (2 - value) * 2
	sprite.visible = true


func play_damage_animation(previous_value: int) -> void:
	damage_animation_id += 1
	var animation_id := damage_animation_id
	if RunManager.player.current_heart == RunManager.player.Hearts.TOMATO:
		sprite.frame = (3 - previous_value) * 2 + 1
	else:
		sprite.frame = (2 - previous_value) * 2 + 1
	await get_tree().create_timer(0.12).timeout
	if animation_id == damage_animation_id:
		sprite.frame = (3 - value) * 2 if RunManager.player.current_heart == RunManager.player.Hearts.TOMATO else (2 - value) * 2
