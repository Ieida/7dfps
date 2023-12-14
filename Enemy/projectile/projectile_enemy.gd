extends Enemy


enum State {IDLE, CHASE, ATTACK}


var state: State = State.IDLE
@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_facing_target = false
@export var projectile: PackedScene = null
@export var shoot_time: float = 1


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
		if state == State.CHASE:
			chase()


func attack():
	is_navigating = false
	is_facing_target = true
	animation_player.play("Attack_start")
	await animation_player.animation_finished
	if state != State.ATTACK: return
	animation_player.play("Attack")
	while state == State.ATTACK:
		shoot()
		await get_tree().create_timer(shoot_time).timeout


func attack_end():
	is_facing_target = false
	animation_player.play("Attack_End")
	await animation_player.animation_finished


func chase():
	animation_player.play("Idle_loop")
	is_navigating = true
	is_facing_target = false
	while state == State.CHASE:
		set_movement_target(target.position)
		await get_tree().create_timer(0.5).timeout


func face_position(pos: Vector3):
	pos.y = $Armature.global_position.y
	pos = $Armature.global_position + -$Armature.global_position.direction_to(pos)
	$Armature.look_at(pos)


func idle():
	is_navigating = false
	is_facing_target = false
	animation_player.play("Idle_loop")


func move_towards():
	super.move_towards()
	
	if is_navigating: face_position(navigation_agent.get_next_path_position())


func set_target(new_target: Node3D):
	super.set_target(new_target)
	raycast.clear_exceptions()
	raycast.add_exception(target as CollisionObject3D)


func shoot():
	var new_projectile = projectile.instantiate()
	get_tree().root.add_child(new_projectile)
	if new_projectile is Projectile:
		new_projectile.global_transform = $Armature/Skeleton3D/Geisha/ShootPoint.global_transform
		new_projectile.add_collision_exception_with($Hitbox)
