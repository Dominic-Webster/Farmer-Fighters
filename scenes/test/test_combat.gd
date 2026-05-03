extends Node2D

@onready var player : Player = $Player
@onready var health_label : Label = $HealthLabel


func _ready() -> void:
	RunManager.start_new_run(player)
	health_label.text = "Health: " + str(player.current_health)
	player.damaged.connect(_update_health)


func _update_health():
	health_label.text = "Health: " + str(player.current_health)
