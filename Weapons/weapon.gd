extends Node3D
class_name Weapon


@export var animation_player: AnimationPlayer
@export var damage: float = 1
var damage_exceptions: Array[Node]


func add_damage_exception(body: Node):
	damage_exceptions.append(body)


func do_damage(victim: Node, damage_amount: float = damage):
	if damage_exceptions.has(victim) or not victim.has_method("take_damage"): return
	
	victim.take_damage(damage_amount)


func remove_damage_exception(body: Node):
	if not damage_exceptions.has(body): return
	
	damage_exceptions.erase(body)


func unholster():
	show()
	animation_player.play("unholster")
	await animation_player.animation_finished


func holster():
	animation_player.play("holster")
	await animation_player.animation_finished
	hide()


func use():
	print("%s is using %s" % [owner, self])
