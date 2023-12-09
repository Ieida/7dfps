extends CharacterBody3D


@export var speed = 5.0


func _physics_process(delta):
	var mtn = -transform.basis.z * speed * delta
	var coll = move_and_collide(mtn)
	if coll:
		queue_free()
