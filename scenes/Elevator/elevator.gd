extends Node2D
class_name Elevator

@onready var anim : AnimationPlayer = $AnimationPlayer
@onready var area2d : Area2D = $Area2D

func _ready():
	z_index = 10
	visible = false
	area2d.body_entered.connect(_on_area2d_body_entered)

func load_in() -> void:
	var player_x : float = RunManager.player.global_position.x
	
	if player_x < 960:
		global_position.x += 200
	else:
		global_position.x -= 200
	
	global_position.y -= 50

func lower() -> void:
	visible = true
	anim.play("lower")
	await anim.animation_finished
	open()

func raise() -> void:
	anim.play("raise")

func open() -> void:
	anim.play("open")

func close() -> void:
	anim.play("close")

# Elevator transition sequence after boss defeat
func _on_area2d_body_entered(body):
	if body is Player:
		await _elevator_transition(body)

func _elevator_transition(player):
	# Hide player
	player.visible = false
	# Close elevator doors and wait for animation
	close()
	await anim.animation_finished
	# Raise elevator and wait for animation
	raise()
	await anim.animation_finished
	# Generate new map and move player to start room
	RunManager.current_floor += 1
	MapGenerationManager.create_new_map()
	# Remove old room (handled by load_room)
	RunManager.current_room = MapGenerationManager._start
	
	if RunManager.current_floor == 5:
		RunManager.ended.emit()
	else:
		RunManager.load_room(MapGenerationManager._start, "C")
	# Show player in new room
	player.visible = true
