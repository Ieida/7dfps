extends Weapon


@export var kunai: PackedScene
@export var throw_force: float = 100
@export var throw_torque: float = 0


func use():
	throw()


func throw():
	# spawn
	var new_kunai: Kunai = kunai.instantiate()
	get_tree().root.add_child(new_kunai)
	
	# setup transform
	new_kunai.transform = global_transform
	
	# set collision avoidance
	for body in damage_exceptions:
		new_kunai.add_collision_exception_with(body)
	
	# apply forces
	new_kunai.apply_impulse_force(-new_kunai.basis.z * throw_force)
