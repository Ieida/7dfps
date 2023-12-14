extends Enemy


enum State {IDLE, CHASE, ATTACK}


var state: State = State.IDLE
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_facing_target = false


func _on_agent_ready():
	set_target(get_tree().get_nodes_in_group("players")[0])


func _ready():
	super._ready()
	idle()


func _process(delta):
	if is_facing_target: face_position(target.position)


func _physics_process(delta):
	super._physics_process(delta)
	
	if state == State.IDLE and can_see_target():
		state = State.ATTACK
		animation_player.clear_queue()
		attack()
	elif state == State.CHASE and can_see_target():
		state = State.ATTACK
		animation_player.clear_queue()
		attack()
	elif state == State.ATTACK and not can_see_target():
		state = State.CHASE
		animation_player.clear_queue()
		await attack_end()
		chase()


func attack():
	is_navigating = false
	is_facing_target = true
	animation_player.play("Shoot")


func attack_end():
	is_facing_target = false


func chase():
	animation_player.play("Walk")
	is_navigating = true
	is_facing_target = false
	while state == State.CHASE:
		set_movement_target(target.position)
		await get_tree().create_timer(0.5).timeout


func face_position(pos: Vector3):
	pos.y = $metarig.global_position.y
	pos = $metarig.global_position + -$metarig.global_position.direction_to(pos)
	$metarig.look_at(pos)


func idle():
	is_navigating = false
	is_facing_target = false
	animation_player.play("Idle")


func move_towards():
	super.move_towards()
	
	if is_navigating: face_position(navigation_agent.get_next_path_position())


func set_target(new_target: Node3D):
	super.set_target(new_target)
	raycast.clear_exceptions()
	raycast.add_exception(target as CollisionObject3D)


func shoot():
	deal_damage()
