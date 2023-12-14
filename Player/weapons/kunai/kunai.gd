extends CharacterBody3D
class_name Kunai


@export var damage: float = 50


func apply_impulse_force(force: Vector3):
	velocity += force


func _physics_process(delta):
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
	deal_damage(collider)
	var t = global_transform
	get_parent().remove_child(self)
	collider.add_child(self)
	global_transform = t


func deal_damage(victim, damage_amount: float = damage):
	if victim is Hitbox:
		victim.take_damage(damage_amount)
	elif victim.has_method("take_damage"):
		victim.take_damage(damage_amount)
