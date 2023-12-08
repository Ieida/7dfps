extends CharacterBody3D


@export_range(0, 1000) var speed = 5.0
var target: Node3D
@export_range(0, 100) var turn_speed: float = 1.0


func _process(delta):
	if target: turn_towards_target(delta)


func _physics_process(delta):
	var mtn = -transform.basis.z * speed * delta
	var coll = move_and_collide(mtn)
	if coll:
		queue_free()


func set_target(new_target: Node3D):
	target = new_target


func turn_towards_target(delta):
	var to = transform.looking_at(target.position)
	transform = transform.interpolate_with(to, turn_speed * delta)
