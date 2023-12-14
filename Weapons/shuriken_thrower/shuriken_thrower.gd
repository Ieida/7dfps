extends Weapon


@export var shuriken: PackedScene
@export_range(0, 360) var arc_angle: float = 90
@export var arc_radius: float = 0.3
@export var shuriken_amount: int = 3:
	set(value):
		shuriken_amount = value if value > 0 else 0
@export var throw_force: float = 100
@export var throw_torque: float = 50


func use():
	throw()


func throw():
	if shuriken_amount < 1: return
	
	var offset_angle = arc_angle / clampf(shuriken_amount - 1, 1, shuriken_amount)
	var starting_angle = offset_angle * (clampf(shuriken_amount - 1, 1, shuriken_amount) / 2)
	var spawned_shurikens: Array[Shuriken] = []
	
	for n in shuriken_amount:
		var spawn_angle = starting_angle - (n * offset_angle)
		# spawn
		var new_shuriken: Shuriken = shuriken.instantiate()
		get_tree().root.add_child(new_shuriken)
		# setup transform
		new_shuriken.transform = global_transform
		new_shuriken.rotate_object_local(Vector3(0, -1, 0), deg_to_rad(180 + spawn_angle))
		new_shuriken.translate_object_local(Vector3(0, 0, arc_radius))
		# set collision avoidance
		for body in damage_exceptions:
			new_shuriken.add_collision_exception_with(body)
		for shur in spawned_shurikens:
			new_shuriken.add_collision_exception_with(shur)
		spawned_shurikens.append(new_shuriken)
		new_shuriken.apply_impulse_force(new_shuriken.basis.z * throw_force)
		new_shuriken.apply_impulse_torque(new_shuriken.basis.y * throw_torque)

