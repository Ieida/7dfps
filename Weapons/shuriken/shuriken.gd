extends CharacterBody3D
class_name Shuriken


@export var damage: float = 20
var angular_velocity: Vector3 = Vector3.ZERO


func apply_impulse_force(force: Vector3):
	velocity += force


func apply_impulse_torque(torque: Vector3):
	angular_velocity += torque


func _physics_process(delta):
	var dir = angular_velocity.normalized()
	var ang = angular_velocity.length()
	rotate(dir.normalized(), ang * delta)
	orthonormalize()
	var collision = move_and_collide(velocity * delta)
	if collision:
		_on_collision(collision.get_collider())


func _on_collision(collider: Object):
	if not (collider is Node): return
	
	set_physics_process(false)
	for e in get_collision_exceptions():
		remove_collision_exception_with(e)
	add_collision_exception_with(collider)
	velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	deal_damage(collider)
	var t = global_transform
	get_parent().remove_child(self)
	collider.add_child(self)
	global_transform = t


func deal_damage(victim: Node, damage_amount: float = damage):
	if not victim.has_method("take_damage"): return
	
	victim.take_damage(damage_amount)
