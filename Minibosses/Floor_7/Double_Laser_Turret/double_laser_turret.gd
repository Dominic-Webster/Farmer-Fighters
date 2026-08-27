extends Enemy
class_name DoubleLaserTurret

@onready var shoot_point : Marker2D = $ShootPoint
@onready var shoot_point_2 : Marker2D = $ShootPoint2

var start_timer : float = 0.5

const SPIN_DURATION : float = 5.0
const RECOVERY_DURATION : float = 0.4
const LASER_DAMAGE_INTERVAL : float = 0.2
const LASER_LENGTH : float = 2000.0

enum State { CHARGING, FIRING, RECOVERING }

var state : State = State.RECOVERING
var state_timer : float = 0.5
var spin_start_rotation : float = 0.0
var spin_elapsed : float = 0.0
var laser_damage_timer : float = 0.0
var laser : Line2D
var laser2 : Line2D


func _ready() -> void:
	super._ready()
	laser = Line2D.new()
	laser.name = "Laser"
	laser.width = 10.0
	laser.default_color = Color(1.0, 0.9, 0.1, 0.95)
	laser.z_index = 10
	laser.visible = false
	add_child(laser)
	laser2 = Line2D.new()
	laser2.name = "Laser2"
	laser2.width = 10.0
	laser2.default_color = Color(1.0, 0.9, 0.1, 0.95)
	laser2.z_index = 10
	laser2.visible = false
	add_child(laser2)


func _physics_process(delta : float) -> void:
	if player == null or is_dead:
		return
	
	velocity = Vector2.ZERO
	move_and_slide()
	
	if start_timer > 0:
		start_timer -= delta
		return
	
	match state:
		State.CHARGING:
			state_timer -= delta
			if state_timer <= 0.0:
				state = State.FIRING
				spin_start_rotation = rotation
				spin_elapsed = 0.0
				laser_damage_timer = LASER_DAMAGE_INTERVAL
				laser.visible = true
				laser2.visible = true
		State.FIRING:
			spin_elapsed += delta
			rotation = spin_start_rotation + TAU * minf(spin_elapsed / SPIN_DURATION, 1.0)
			_update_lasers(delta)
			if spin_elapsed >= SPIN_DURATION:
				laser.visible = false
				laser2.visible = false
				state = State.RECOVERING
				state_timer = RECOVERY_DURATION
		State.RECOVERING:
			var target_rotation := _get_player_rotation()
			rotation = lerp_angle(rotation, target_rotation, minf(delta / RECOVERY_DURATION, 1.0))
			state_timer -= delta
			if state_timer <= 0.0:
				state = State.CHARGING
				anim.play("charge")
				state_timer = anim.current_animation_length


func _aim_at_player() -> void:
	rotation = _get_player_rotation()


func _get_player_rotation() -> float:
	var direction := (player.global_position - global_position).normalized()
	if direction == Vector2.ZERO:
		return rotation
	return direction.angle() + PI / 2


func _update_lasers(delta : float) -> void:
	var hit_player := false
	hit_player = _update_single_laser(shoot_point, laser, hit_player)
	hit_player = _update_single_laser(shoot_point_2, laser2, hit_player)

	if hit_player:
		laser_damage_timer += delta
		if laser_damage_timer >= LASER_DAMAGE_INTERVAL:
			player.take_damage(1)
			laser_damage_timer = 0.0
	else:
		laser_damage_timer = 0.0


func _update_single_laser(emitter : Marker2D, line : Line2D, hit_player : bool) -> bool:
	var direction := (emitter.global_position - global_position).normalized()
	if direction == Vector2.ZERO:
		direction = Vector2.UP.rotated(rotation)

	var start := emitter.global_position
	var end := start + direction * LASER_LENGTH
	var query := PhysicsRayQueryParameters2D.create(start, end)
	query.collide_with_areas = true
	query.collide_with_bodies = true
	query.exclude = [self]
	var hit := get_world_2d().direct_space_state.intersect_ray(query)
	if not hit.is_empty():
		end = hit.position
		var collider = hit.collider
		if collider == player or (collider is Node and collider.get_parent() == player):
			hit_player = true

	line.points = PackedVector2Array([to_local(start), to_local(end)])
	return hit_player


func die():
	if not is_dead:
		died.emit()
		is_dead = true
		if laser != null:
			laser.visible = false
		if laser2 != null:
			laser2.visible = false
		hurt_box.set_deferred("monitoring", false)
		move_speed = 0
		anim.stop()
		anim.play("die")
		await anim.animation_finished
		queue_free()
