extends Weapon


@export var shuriken: PackedScene
@export_range(0, 360) var arc_angle: float = 90
@export var arc_radius: float = 0.3
@export var shuriken_amount: int = 3:
	set(value):
		shuriken_amount = value if value > 0 else 0
@export var throw_force: float = 100
@export var throw_torque: float = 50
@export var ammo: int = 6


func has_ammo() -> bool:
	return ammo >= shuriken_amount


func add_ammo(amount: int = 1):
	var had_ammo := ammo >= shuriken_amount
	ammo += amount
	if not is_holstered and not is_being_used and not had_ammo and ammo >= shuriken_amount:
		animation_player.play("unholster")
		await animation_player.animation_finished
		show()


var is_being_used = false
func use():
	if ammo < shuriken_amount or is_being_used: return
	is_being_used = true
	
	animation_player.play("throw")
	await animation_player.animation_finished
	
	if ammo < shuriken_amount:
		hide()
		is_being_used = false
		return
	
	animation_player.play("unholster")
	await animation_player.animation_finished
	
	is_being_used = false


func throw():
	ammo -= shuriken_amount
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

