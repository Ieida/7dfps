extends Weapon
class_name WeaponOwner


@export var weapon: Weapon
@export var animation_player: AnimationPlayer


func add_damage_exception(body: Node):
	weapon.add_damage_exception(body)


func holster():
	animation_player.play("holster")
	await animation_player.animation_finished


func remove_damage_exception(body: Node):
	weapon.remove_damage_exception(body)


func unholster() -> Weapon:
	animation_player.play("unholster")
	await animation_player.animation_finished
	return weapon
