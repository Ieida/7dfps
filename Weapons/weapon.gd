extends Node3D
class_name Weapon


@export var damage: float = 1
var damage_avoidant_bodies: Array[Node]


func avoid_damaging_body(body: Node):
	damage_avoidant_bodies.append(body)


func stop_avoiding_damaging_body(body: Node):
	if not damage_avoidant_bodies.has(body): return
	
	damage_avoidant_bodies.erase(body)


func unholster():
	print("%s unholstering %s" % [owner, self])


func holster():
	print("%s holstering %s" % [owner, self])


func use():
	print("%s is using %s" % [owner, self])


func do_damage(victim: Node, damage_amount: float = damage):
	if damage_avoidant_bodies.has(victim) or not victim.has_method("take_damage"): return
	
	victim.take_damage(damage_amount)
