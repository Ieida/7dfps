extends CharacterBody3D
class_name Enemy


## Emitted when the NavigationAgent is ready to query the NavigationServer
signal agent_ready


@export var movement_speed: float = 0.5
var target: Node3D = null
@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var is_navigating = false
@export var health: float = 100
@onready var raycast: RayCast3D = $RayCast3D
@export var damage: float = 30


func _ready():
	call_deferred("agent_setup")


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func _process(delta):
	pass


func _physics_process(delta):
	if is_navigating: move_towards()


func agent_setup():
	await get_tree().physics_frame
	agent_ready.emit()


func set_target(new_target: Node3D):
	target = new_target


func move_towards():
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()


func can_see_target():
	if not target: return false
	raycast.target_position = target.global_position - global_position
	raycast.force_raycast_update()
	return not raycast.is_colliding()


func take_damage(amount: float):
	health -= amount
	if health <= 0:
		die()


func deal_damage(amount: float = damage):
	target.take_damage(amount)


func die():
	queue_free()
