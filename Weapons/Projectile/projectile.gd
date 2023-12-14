extends CharacterBody3D
class_name Projectile


signal collided(collision: KinematicCollision3D)


@export var damage: float = 1
@export var speed: float = 2


func _physics_process(delta):
	var movement = global_basis.z * speed * delta
	var collision = move_and_collide(movement)
	if collision:
		collided.emit(collision)


func _on_collided(collision: KinematicCollision3D):
	var collider = collision.get_collider()
	if collider is Hitbox:
		collider.take_damage(damage)
	queue_free()
