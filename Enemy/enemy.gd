extends CharacterBody3D
class_name Enemy


var movement_speed: float = 0.5
var target: Node3D = null

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D


func _ready():
	target = get_tree().get_nodes_in_group("players")[0]

	# Make sure to not await during _ready.
	call_deferred("actor_setup")


func actor_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame

	# Now that the navigation map is no longer empty, set the movement target.
	while true:
		set_movement_target(target.position)
		await get_tree().create_timer(0.5).timeout


func set_movement_target(movement_target: Vector3):
	navigation_agent.set_target_position(movement_target)


func _physics_process(delta):
	if navigation_agent.is_navigation_finished():
		return

	var current_agent_position: Vector3 = global_position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	print(next_path_position)

	velocity = current_agent_position.direction_to(next_path_position) * movement_speed
	move_and_slide()
