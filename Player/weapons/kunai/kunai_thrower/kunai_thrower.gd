extends Weapon


@export var kunai: PackedScene
@export var throw_force: float = 100
#@export var throw_torque: float = 0
@export var ammo: int = 3


func has_ammo() -> bool:
	return ammo >= 1


func add_ammo(amount: int = 1):
	var had_ammo := ammo > 0
	ammo += amount
	if not is_holstered and not is_being_used and not had_ammo and ammo > 0:
		animation_player.play("unholster")
		await animation_player.animation_finished
		show()


var is_being_used = false
func use():
	if ammo < 1 or is_being_used: return
	is_being_used = true
	
	animation_player.play("throw")
	await animation_player.animation_finished
	
	if ammo < 1:
		hide()
		is_being_used = false
		return
	
	animation_player.play("unholster")
	await animation_player.animation_finished
	
	is_being_used = false


func throw():
	ammo -= 1
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
