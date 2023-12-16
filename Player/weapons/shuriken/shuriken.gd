extends StaticBody3D
class_name Shuriken


@export var damage: float = 20
var velocity: Vector3 = Vector3.ZERO
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
	if collider.get_collision_layer_value(2):
		add_collision_exception_with(collider)
		deal_damage(collider)
		return
	
	# stop the shuriken
	set_physics_process(false)
	for e in get_collision_exceptions():
		if e: remove_collision_exception_with(e)
	add_collision_exception_with(collider)
	velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	
	# do damage
	deal_damage(collider)
	
	# reparent
	var t = global_transform
	get_parent().remove_child(self)
	collider.add_child(self)
	global_transform = t
	
	# turn into pickup
	set_collision_layer_value(4, false)
	set_collision_layer_value(6, true)
	set_collision_mask_value(1, false)
	set_collision_mask_value(2, false)
	add_to_group("pickups")


func deal_damage(victim, damage_amount: float = damage):
	if victim is Hitbox:
		victim.take_damage(damage_amount)
	elif victim.has_method("take_damage"):
		victim.take_damage(damage_amount)
